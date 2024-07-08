import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:flutter_rust/pages/chat/messages_view.dart';
import 'package:flutter_rust/pages/chat/message_box.dart';
import 'package:flutter_rust/pages/chat/reply_box.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final currentUser = Supabase.instance.client.auth.currentUser;
    final other = controller.chat.value.participants.firstWhere((u) => u.id != currentUser?.id);

    return Obx(
      () => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(other.name),
            bottom: controller.loading()
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(5),
                    child: LinearProgressIndicator(),
                  )
                : null,
          ),
          body: Column(
            children: [
              const Expanded(
                child: MessagesView(),
              ),
              Container(
                color: Get.theme.colorScheme.primary.withOpacity(0.15),
                child: const SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      ReplyBox(),
                      MessageBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
