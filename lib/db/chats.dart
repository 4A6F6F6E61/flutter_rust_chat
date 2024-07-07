import 'dart:developer';

import 'package:flutter_rust/db/db.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Chats {
  Chats._();

  static Stream<List<Map<String, dynamic>>> getUserChats() {
    try {
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      if (currentUserId == null) {
        throw Exception('No current user logged in');
      }

      return DB.chatUser.select('chat_id, chat:chats(*)').eq('user_id', currentUserId).asStream();
    } catch (error) {
      log('Error fetching user chats: $error');
      return const Stream.empty();
    }
  }

  static Future<List<String>> getParticipants(int chatId) async {
    try {
      final response = await DB.chatUser.select('user_id').eq('chat_id', chatId);

      return response.map((e) => e['user_id'] as String).toList();
    } catch (error) {
      log('Error fetching chat participants: $error');
      return <String>[];
    }
  }
}
