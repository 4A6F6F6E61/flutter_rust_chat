import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/global.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomSheetRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  CustomSheetRoute({required this.builder});

  @override
  Color get barrierColor => CupertinoColors.black;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(animation),
      child: child,
    );
  }
}

class NewChatModal extends StatefulWidget {
  const NewChatModal({super.key});

  @override
  State<NewChatModal> createState() => _NewChatModalState();
}

class _NewChatModalState extends State<NewChatModal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: DB.users.select('id, name').asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Text('No users');
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data?[index]['name']),
                onTap: () {
                  createChat(snapshot.data?[index]['id']);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> createChat(String userId) async {
    int? chatId;
    try {
      // Insert chat and get the chat ID
      final chatResponse = await DB.chats.insert({}).select().single();
      chatId = chatResponse['id'];

      // Insert current user into chat_user
      final currentUserId = Supabase.instance.client.auth.currentUser?.id;
      await DB.chatUser.insert({
        'chat_id': chatId,
        'user_id': currentUserId,
      });

      // Insert other user into chat_user
      await DB.chatUser.insert({
        'chat_id': chatId,
        'user_id': userId,
      });

      // Close the dialog or perform other success actions
      Get.back();
    } catch (error) {
      // Rollback: Delete the chat and chat_user records if any error occurs
      if (chatId != null) {
        await DB.chats.delete().eq('id', chatId);
        await DB.chatUser.delete().eq('chat_id', chatId);
      }

      // Handle the error
      log('Error creating chat: $error');
      // Optionally show a Snackbar or Dialog to inform the user
      Get.snackbar("Error", "Failed to create chat. Please try again.");
    }
  }
}
