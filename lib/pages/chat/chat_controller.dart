import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_rust/db/db_chat.dart';
import 'package:flutter_rust/db/db_message.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:flutter_rust/db/messages.dart';
import 'package:flutter_rust/db/db.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatController extends GetxController {
  RxBool loading = true.obs;

  ScrollController scrollController = ScrollController();

  Rx<DBChat> chat = const DBChat(
          id: -1,
          participants: [
            DBUser(id: "-1", createdAt: "", name: "ERROR", email: "ERROR"),
          ],
          createdAt: "")
      .obs;

  RxList<DBMessage> messages = <DBMessage>[].obs;

  Rx<DBMessage?> replyTo = Rx<DBMessage?>(null);

  TextEditingController messageController = TextEditingController();

  RxMap<int, GlobalKey> messageKeys = RxMap<int, GlobalKey>();
  RxMap<String, CachedNetworkImageProvider> images = RxMap<String, CachedNetworkImageProvider>();

  @override
  void onInit() {
    chat(Get.arguments);
    messages.bindStream(Messages.getAll(chat.value.id));

    ever(messages, (_) async {
      await loadImages();
      loading.value = false;
    });
    super.onInit();
  }

  void scrollToMessage(int messageId) async {
    final key = messageKeys[messageId];

    if (key == null) return;

    var context = key.currentContext;

    log("Context is null: ${context == null}");

    while (context == null) {
      await scrollController.animateTo(
        scrollController.offset + 50, // Adjust the value as needed
        duration: const Duration(milliseconds: 10),
        curve: Curves.easeInOut,
      );
      context = key.currentContext;
    }

    Scrollable.ensureVisible(
      // ignore: use_build_context_synchronously
      context,
      duration: const Duration(milliseconds: 500),
    );
  }

  Future<void> loadImages() async {
    for (final message in messages) {
      if (message.type == MessageType.image) {
        final url = await Supabase.instance.client.storage
            .from('media')
            .createSignedUrl(message.content, 60);
        final image = CachedNetworkImageProvider(url);
        images[message.content] = image;

        log('Loaded image: $url');
      }
    }
  }

  CachedNetworkImageProvider? getImageProvider(String url) {
    return images[url];
  }

  void messageSwipeRight(DBMessage message) {
    log('Swiped right on message ${message.id}');
  }

  void messageSwipeLeft(DBMessage message) {
    log('Swiped left on message ${message.id}');

    replyTo(message);
  }

  void clearReplyTo() {
    replyTo.value = null;
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    }
    loading.value = true;
    try {
      await DB.messages.insert({
        'chat_id': chat.value.id,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'content': messageController.text,
        'type': 'text',
        'reply_to': replyTo.value?.id,
      });

      replyTo.value = null;
      messageController.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<XFile?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  void uploadImage() async {
    final chatId = chat.value.id;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    try {
      final image = await pickImage();

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();
      final fileName = path.basename(image.path);
      final filePath = 'chats/$chatId/$userId/$fileName';

      final response =
          await Supabase.instance.client.storage.from('media').uploadBinary(filePath, bytes);

      await DB.messages.insert({
        'chat_id': chat.value.id,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
        'content': filePath,
        'type': 'image',
        'reply_to': replyTo.value?.id,
      });

      replyTo.value = null;
      messageController.clear();
    } catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }

  void uploadVideo() {
    log('Uploading video');
  }

  void uploadFile() {
    log('Uploading file');
  }
}
