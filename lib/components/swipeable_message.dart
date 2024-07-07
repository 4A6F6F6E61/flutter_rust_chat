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
        duration: const Duration(milliseconds: 200), // Faster animation
        transform: Matrix4.translationValues(_offset, 0, 0),
        child: Container(
          color: Colors.transparent, // Ensure the container covers the entire message widget
          child: BubbleSpecialThree(
            text: widget.message.content,
            color: widget.isSender ? Colors.blue : Colors.blueGrey,
            tail: widget.tail,
            textStyle: const TextStyle(color: Colors.white, fontSize: 16),
            isSender: widget.isSender,
          ),
        ),
      ),
    );
  }
}
