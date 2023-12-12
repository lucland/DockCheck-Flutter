import 'dart:async';

import 'package:flutter/foundation.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;

  BackgroundService._internal() {
    _startPeriodicTask();
  }

  Timer? _timer;

  void _startPeriodicTask() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      // Call your function here
      if (kDebugMode) {
        print("Background task executed");
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
