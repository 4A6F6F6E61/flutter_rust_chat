import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/db/db_message.dart';

class SwipeableMessage extends StatefulWidget {
  final DBMessage message;
  final bool isSender;
  final bool tail;
  final void Function(DBMessage) onSwipeRight;
  final void Function(DBMessage) onSwipeLeft;

  const SwipeableMessage({
    super.key,
    required this.message,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Faster animation
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Container(
          color: Colors.transparent, // Ensure the container covers the entire message widget
          child: Align(
            alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(4),
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
                  child: Text(
                    widget.message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  // tail: widget.tail,
                  // isSender: widget.isSender,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
