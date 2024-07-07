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

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axisAlignment: -1.0,
                            child: child,
                          );
                        },
                        child: controller.replyTo() != null
                            ? Container(
                                key: ValueKey<int>(1),
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Icon(
                                            Icons.reply,
                                            color: Colors.blue,
                                          ),
                                          const VerticalDivider(
                                            width: 30,
                                            thickness: 2,
                                            color: Colors.blue,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.replyTo.value!.userId == currentUser?.id
                                                    ? 'Reply to You'
                                                    : 'Reply to ${other.name}',
                                                style: const TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Text(
                                                controller.replyTo.value!.content,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: controller.clearReplyTo,
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                key: ValueKey<int>(0),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6, left: 16, right: 16, top: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.messageController,
                                decoration: InputDecoration(
                                  hintText: 'Message',
                                  fillColor: Get.theme.colorScheme.primary.withOpacity(0.1),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(left: 12, right: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
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
