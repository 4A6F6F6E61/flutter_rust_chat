import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust/db/chats.dart';
import 'package:flutter_rust/pages/home/tabs/chats/chats_controller.dart';
import 'package:flutter_rust/pages/home/tabs/chats/new_chat_modal.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatsController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        // make it large
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: newChat,
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.chats.length,
          itemBuilder: (context, index) {
            final currentUser = Supabase.instance.client.auth.currentUser;
            final other =
                controller.chats[index].participants.firstWhere((u) => u.id != currentUser?.id);
            log(controller.chats[index].createdAt);
            return ListTile(
              title: Text(other.name),
              onTap: () {
                // open chat
              },
            );
          },
        ),
      ),
    );
  }

  void test() async {
    final data = Chats.getUserChats();
    log(data.toString());
  }

  void newChat() {
    Get.bottomSheet(const NewChatModal());
  }
}
