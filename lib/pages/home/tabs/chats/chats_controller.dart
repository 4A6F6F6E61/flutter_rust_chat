import 'package:flutter_rust/db/chats.dart';
import 'package:flutter_rust/db/db_chat.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController {
  RxList<Map<String, dynamic>> chatsRaw = <Map<String, dynamic>>[].obs;

  RxList<DBChat> chats = <DBChat>[].obs;

  @override
  void onInit() {
    chatsRaw.bindStream(Chats.getUserChats());

    ever(chatsRaw, (value) async {
      chats.value = await Future.wait(value.map((e) => DBChat.fromSupabase(e)).toList());
    });

    super.onInit();
  }
}
