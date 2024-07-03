import 'package:flutter/cupertino.dart';
import 'package:flutter_rust/pages/login/login_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login'),
              const SizedBox(height: 16),
              CupertinoTextField(
                placeholder: 'Email',
                controller: controller.emailController,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                placeholder: 'Password',
                obscureText: true,
                controller: controller.passwordController,
              ),
              const SizedBox(height: 8),
              CupertinoButton(
                onPressed: controller.login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
