import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust/db/db_chat.dart';
import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/db/messages.dart';
import 'package:flutter_rust/global.dart';
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

  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    chat(Get.arguments);
    messages.bindStream(Messages.getAll(chat.value.id));
    super.onInit();
  }

  void sendMessage() async {
    try {
      final chatResponse = await DB.messages
          .insert({
            'chat_id': chat.value.id,
            'user_id': Supabase.instance.client.auth.currentUser!.id,
            'content': messageController.text,
            'type': 'text',
          })
          .select()
          .single();

      log(chatResponse.toString());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}