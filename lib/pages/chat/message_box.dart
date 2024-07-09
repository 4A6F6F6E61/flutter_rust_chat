import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';

enum AttachmentType {
  image,
  video,
  file,
}

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
            onPressed: () async {
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

              final value = await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  Rect.fromPoints(
                    buttonPosition,
                    buttonPosition,
                  ),
                  Offset.zero & overlay.size,
                ),
                items: const [
                  PopupMenuItem<AttachmentType>(
                    value: AttachmentType.image,
                    child: Text('Image'),
                  ),
                  PopupMenuItem<AttachmentType>(
                    value: AttachmentType.video,
                    child: Text('Video'),
                  ),
                  PopupMenuItem<AttachmentType>(
                    value: AttachmentType.file,
                    child: Text('File'),
                  ),
                ],
              );
              switch (value) {
                case AttachmentType.image:
                  controller.uploadImage();
                  break;
                case AttachmentType.video:
                  controller.uploadVideo();
                  break;
                case AttachmentType.file:
                  controller.uploadFile();
                  break;
                default:
                  break;
              }
            },
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
