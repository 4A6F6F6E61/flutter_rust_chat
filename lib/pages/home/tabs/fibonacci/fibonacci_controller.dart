import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rust/src/rust/api/simple.dart' as Rust;
import 'package:flutter_rust/src/rust/frb_generated.dart';
import 'package:get/get.dart';

class FibonacciController extends GetxController {
  final dartTextController = TextEditingController();
  final rustTextController = TextEditingController();

  final RxInt dartResult = 0.obs;
  final RxInt dartTime = 0.obs;
  final RxBool dartLoading = false.obs;

  final Rx<BigInt> rustResult = BigInt.zero.obs;
  final RxInt rustTime = 0.obs;
  final RxBool rustLoading = false.obs;

  Future<void> dart() async {
    if (dartLoading()) return;

    dartLoading(true);
    final int n = int.tryParse(dartTextController.text) ?? 0;
    final Stopwatch stopwatch = Stopwatch()..start();
    int result = await compute(fibonacci, n);
    log('Dart: $result', name: 'INFO');
    dartTime(stopwatch.elapsedMilliseconds);
    dartResult(result);
    dartLoading(false);
  }

  Future<void> rust() async {
    if (rustLoading()) return;

    rustLoading(true);

    final BigInt n = BigInt.tryParse(rustTextController.text) ?? BigInt.zero;
    final Stopwatch stopwatch = Stopwatch()..start();
    BigInt result = await compute(rustFib, n);

    log('Rust: $result', name: 'INFO');

    rustTime(stopwatch.elapsedMilliseconds);
    rustResult(result);

    rustLoading(false);
  }

  static Future<BigInt> rustFib(BigInt n) async {
    // Initialize the Rust library here because this runs
    // on a separate isolate
    await RustLib.init();

    return Rust.fibonacci(n: n);
  }

  // Define the Fibonacci function
  static int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }
}
