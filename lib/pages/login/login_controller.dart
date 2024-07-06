import 'package:flutter/cupertino.dart';
import 'package:flutter_rust/main.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    try {
      await Supabase.instance.client.auth
          .signInWithPassword(email: emailController.text, password: passwordController.text);
      checkIfUserExists();
    } on AuthException catch (e) {
      Get.snackbar('Error', e.toString());
      rethrow;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
