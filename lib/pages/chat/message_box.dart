import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
          ),
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
    );
  }
}
