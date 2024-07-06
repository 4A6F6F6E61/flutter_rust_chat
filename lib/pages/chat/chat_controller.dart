import 'package:flutter_rust/db/db_chat.dart';
import 'package:flutter_rust/db/db_user.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  Rx<DBChat> chat = const DBChat(
          id: -1,
          participants: [
            DBUser(id: "-1", createdAt: "", name: "ERROR", email: "ERROR"),
          ],
          createdAt: "")
      .obs;

  @override
  void onInit() {
    chat(Get.arguments);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
