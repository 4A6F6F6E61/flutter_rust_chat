import 'dart:developer';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(other.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView(children: [
                Center(
                  child: Text(controller.chat.value.createdAt),
                ),
              ]),
            ),
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
