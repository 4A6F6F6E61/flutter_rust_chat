import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rust/pages/home/tabs/fibonacci/fibonacci_controller.dart';
import 'package:get/get.dart';

class FibonacciTab extends StatelessWidget {
  const FibonacciTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FibonacciController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fibonacci'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Text('Dart:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: controller.dartTextController,
                keyboardType: TextInputType.number,
                placeholder: 'Enter a number',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: controller.dart,
                child: Obx(
                  () => controller.dartLoading.value
                      ? const CupertinoActivityIndicator()
                      : const Text('Calculate'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  'Result: ${controller.dartResult.value}; Time: ${controller.dartTime.value}ms',
                ),
              ),
            ),
            const Text('Rust:'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: controller.rustTextController,
                keyboardType: TextInputType.number,
                placeholder: 'Enter a number',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: controller.rust,
                child: Obx(
                  () => controller.rustLoading.value
                      ? const CupertinoActivityIndicator()
                      : const Text('Calculate'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  'Result: ${controller.rustResult.value}; Time: ${controller.rustTime.value}ms',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
