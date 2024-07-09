import 'package:flutter/material.dart';
import 'package:flutter_rust/components/swipeable_message.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Obx(
      () => ListView(
        controller: controller.scrollController,
        reverse: true,
        children: controller.messages.reversed.map((message) {
          final isSender = message.userId == Supabase.instance.client.auth.currentUser?.id;
          bool tail = false;

          if (controller.messages.last == message ||
              controller.messages[controller.messages.indexOf(message) + 1].userId !=
                  message.userId) {
            tail = true;
          }
          controller.messageKeys[message.id] = GlobalKey();

          if (message.replyTo == null) {
            return SwipeableMessage(
              key: controller.messageKeys[message.id],
              message: message,
              isSender: isSender,
              tail: tail,
              onSwipeLeft: controller.messageSwipeLeft,
              onSwipeRight: controller.messageSwipeRight,
            );
          }

          final replyContent = controller.messages.firstWhere((m) => m.id == message.replyTo);
          final replyUser =
              controller.chat.value.participants.firstWhere((u) => u.id == replyContent.userId);

          return SwipeableMessage(
            key: controller.messageKeys[message.id],
            message: message,
            replyContent: replyContent,
            replyUser: replyUser,
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
