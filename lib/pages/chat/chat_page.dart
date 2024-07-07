import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust/components/swipeable_message.dart';
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
          const Expanded(
            child: MessagesView(),
          ),
          Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            child: SafeArea(
              top: false,
              child: Obx(
                () => Column(
                  children: [
                    if (controller.replyTo.value != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(controller.replyTo.value!.content),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                controller.replyTo(null);
                              },
                            ),
                          ],
                        ),
                      ),
                    Padding(
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
                  ],
                ),
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
          return SwipeableMessage(
            message: message,
            isSender: isSender,
            tail: tail,
            onSwipeLeft: controller.messageSwipeLeft,
            onSwipeRight: controller.messageSwipeRight,
          );
        }).toList(),
      ),
    );
  }
}
