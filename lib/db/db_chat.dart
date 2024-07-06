import 'package:flutter_rust/db/chats.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/db/users.dart';

class DBChat {
  final int id;
  final List<DBUser> participants;
  final String createdAt;

  const DBChat({required this.id, required this.participants, required this.createdAt});

  static Future<DBChat> fromSupabase(Map<String, dynamic> chat) async {
    final p =
        (await Chats.getParticipants(chat['chat_id'] as int)).map((e) => Users.get(e)).toList();

    final participants = await Future.wait(p);

    return DBChat(
      id: chat['chat_id'] as int,
      participants: participants,
      createdAt: chat["chat"]['created_at'],
    );
  }
}
