import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/home/tabs/chats/new_chat_modal.dart';
import 'package:get/get.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

class ChatsTab extends StatelessWidget {
  const ChatsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        children: [
          ListTile(
            title: const Text('New Chat'),
            onTap: () => newChat(),
          ),
        ],
      ),
    );
  }

  void newChat() {
    Get.bottomSheet(
      const NewChatModal(),
      isScrollControlled: true,
    );
  }
}
