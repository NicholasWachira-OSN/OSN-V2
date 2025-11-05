import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../notifications/notification_service.dart';

class AuthFlow {
  // Login/Register success flow: show success notification, wait, then navigate
  static Future<void> runSuccess({
    required BuildContext context,
    required Future<void> Function() action,
    required String successTitle,
    required String successBody,
    required String navigateTo,
    int delayMs = 1200,
  }) async {
    assert(() { debugPrint('[AuthFlow] runSuccess start -> $navigateTo'); return true; }());
    await action();

    if (!context.mounted) return;

    await NotificationService.showSuccess(successTitle, successBody);

    // Allow heads-up to be visible
    await Future.delayed(Duration(milliseconds: delayMs));

    if (context.mounted) {
      assert(() { debugPrint('[AuthFlow] navigating to $navigateTo'); return true; }());
      context.go(navigateTo);
    }
  }

  // Logout flow: show info first, wait, then logout and navigate
  static Future<void> runLogout({
    required BuildContext context,
    required Future<void> Function() logoutAction,
    String infoTitle = 'Logged Out',
    String infoBody = 'You have been successfully logged out. See you again soon!',
    String navigateTo = '/login',
    int delayMs = 1500,
  }) async {
    if (!context.mounted) return;

    assert(() { debugPrint('[AuthFlow] runLogout -> show info'); return true; }());
    await NotificationService.showInfo(infoTitle, infoBody);

    await Future.delayed(Duration(milliseconds: delayMs));

    assert(() { debugPrint('[AuthFlow] runLogout -> perform logout'); return true; }());
    await logoutAction();

    if (context.mounted) {
      assert(() { debugPrint('[AuthFlow] runLogout -> navigating to $navigateTo'); return true; }());
      context.go(navigateTo);
    }
  }
}
