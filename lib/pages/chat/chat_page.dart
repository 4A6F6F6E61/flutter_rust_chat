import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final currentUser = Supabase.instance.client.auth.currentUser;
    final other = controller.chat.value.participants.firstWhere((u) => u.id != currentUser?.id);

    log(controller.messages.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(other.name),
      ),
      body: Column(
        children: [
          const Expanded(
            child: MessagesView(),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(
                        hintText: 'Message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: controller.sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Obx(
      () => ListView(
        reverse: true,
        children: controller.messages.reversed.map((message) {
          final isSender = message.userId == Supabase.instance.client.auth.currentUser?.id;
          bool tail = false;
          if (controller.messages.last == message ||
              controller.messages[controller.messages.indexOf(message) + 1].userId !=
                  message.userId) {
            tail = true;
          }
          return BubbleSpecialThree(
            text: message.content,
            color: isSender ? Colors.blue : Colors.blueGrey,
            tail: tail,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            isSender: isSender,
          );
        }).toList(),
      ),
    );
  }
}
