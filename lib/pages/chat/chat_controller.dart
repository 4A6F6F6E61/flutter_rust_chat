import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust/db/db_chat.dart';
import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/db/messages.dart';
import 'package:flutter_rust/db/db.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  Rx<DBChat> chat = const DBChat(
          id: -1,
          participants: [
            DBUser(id: "-1", createdAt: "", name: "ERROR", email: "ERROR"),
          ],
          createdAt: "")
      .obs;

  RxList<DBMessage> messages = <DBMessage>[].obs;

  Rx<DBMessage?> replyTo = Rx<DBMessage?>(null);

  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    chat(Get.arguments);
    messages.bindStream(Messages.getAll(chat.value.id));
    super.onInit();
  }

  void messageSwipeRight(DBMessage message) {
    log('Swiped right on message ${message.id}');
  }

  void messageSwipeLeft(DBMessage message) {
    log('Swiped left on message ${message.id}');

    replyTo(message);
  }

  void clearReplyTo() {
    replyTo.value = null;
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    try {
      final chatResponse = await DB.messages
          .insert({
            'chat_id': chat.value.id,
            'user_id': Supabase.instance.client.auth.currentUser!.id,
            'content': messageController.text,
            'type': 'text',
            'reply_to': replyTo.value?.id,
          })
          .select()
          .single();

      log(chatResponse.toString());

      replyTo.value = null;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
