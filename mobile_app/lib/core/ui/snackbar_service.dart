import 'package:flutter/material.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void success(String message) =>
      show(message, backgroundColor: Colors.green.shade700);
  static void error(String message) =>
      show(message, backgroundColor: Colors.red.shade700);
  static void info(String message) =>
      show(message, backgroundColor: Colors.blueGrey.shade700);
}
