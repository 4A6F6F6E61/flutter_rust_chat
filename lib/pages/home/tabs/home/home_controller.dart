import 'dart:developer';

import 'package:flutter_rust/pages/home/tabs/chats/chats_tab.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentPageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentPageIndex, (i) {
      final newPage = switch (i) {
        0 => "/chats",
        1 => "/fibonacci",
        2 => "/settings",
        _ => "/chats",
      };

      log('Switching to $newPage', name: 'INFO');

      Get.offAndToNamed(newPage, id: 1);
    });
  }
}
