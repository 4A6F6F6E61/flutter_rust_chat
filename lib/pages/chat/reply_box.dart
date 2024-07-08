import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReplyBox extends StatelessWidget {
  const ReplyBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final currentUser = Supabase.instance.client.auth.currentUser;
    final other = controller.chat.value.participants.firstWhere((u) => u.id != currentUser?.id);

    return Obx(
      () => AnimatedSwitcher(
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
                key: const ValueKey<int>(1),
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntrinsicHeight(
                      child: Row(
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
                          Container(
                            constraints:
                                BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.replyTo.value!.userId == currentUser?.id
                                      ? 'Reply to You'
                                      : 'Reply to ${other.name}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
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
                key: const ValueKey<int>(0),
              ),
      ),
    );
  }
}
