import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/pages/chat/chat_controller.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SwipeableMessage extends StatefulWidget {
  final DBMessage message;
  final DBMessage? replyContent;
  final DBUser? replyUser;
  final bool isSender;
  final bool tail;
  final void Function(DBMessage) onSwipeRight;
  final void Function(DBMessage) onSwipeLeft;

  const SwipeableMessage({
    super.key,
    required this.message,
    this.replyContent,
    this.replyUser,
    required this.isSender,
    required this.tail,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage> {
  double _offset = 0.0;
  final GlobalKey _key = GlobalKey();

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      setState(() {
        _offset += details.primaryDelta!;
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    log("Offset: $_offset");
    try {
      if (_offset > 80) {
        // Adjust the threshold as needed
        widget.onSwipeRight(widget.message);
        setState(() {
          _offset = 0; // Reset offset after triggering swipe right action
        });
      } else if (_offset < -80) {
        // Add swipe left action here
        widget.onSwipeLeft(widget.message);
        setState(() {
          _offset = 0; // Reset offset after triggering swipe left action
        });
      } else {
        setState(() {
          _offset = 0;
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _showContextMenu(BuildContext context) {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: TextButton.icon(
            icon: const Icon(Icons.copy),
            label: const Text('Copy message'),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: widget.message.content));
              Get.back();
            },
          ),
        ),
        PopupMenuItem(
          child: TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            onPressed: () {
              // TODO: Handle delete action
              Navigator.of(context).pop();
            },
          ),
        ),
        // Add more menu items here
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onLongPress: () {
        _showContextMenu(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Faster animation
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Container(
          color: Colors.transparent, // Ensure the container covers the entire message widget
          child: Align(
            alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Builder(
              key: _key,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: (!widget.isSender) && widget.tail
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                      bottomRight: widget.isSender && widget.tail
                          ? const Radius.circular(0)
                          : const Radius.circular(16),
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                    ),
                    color: widget.isSender ? Colors.blue : Colors.blueGrey,
                  ),
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (widget.message.replyTo != null &&
                            widget.replyContent != null &&
                            widget.replyUser != null)
                          ReplyText(reply: widget.replyContent!, from: widget.replyUser!),
                        if (widget.message.type == MessageType.image)
                          Obx(
                            () => chatController.images[widget.message.content] != null
                                ? Image(
                                    image: chatController.images[widget.message.content]!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  )
                                : const SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          )
                        else if (widget.message.type == MessageType.text)
                          Text(
                            widget.message.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ReplyText extends StatelessWidget {
  const ReplyText({super.key, required this.reply, required this.from});

  final DBMessage reply;
  final DBUser from;
  final double radius = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                ),
              ),
              width: 4,
            ),
            Expanded(
              // Add Expanded here
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      reply.content,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      softWrap: true, // Ensure the text wraps
                      maxLines: null, // Allow unlimited lines
                      overflow: TextOverflow.visible, // Ensure overflow is visible
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
