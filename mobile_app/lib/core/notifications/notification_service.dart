import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static const String _channelKey = 'basic_channel';

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // No icon needed for foreground notifications
      [
        NotificationChannel(
          channelKey: _channelKey,
          channelName: 'General Notifications',
          channelDescription: 'In-app notifications for user feedback',
          defaultColor: const Color(0xFF673AB7),
          ledColor: const Color(0xFF673AB7),
          importance: NotificationImportance.Max,
          channelShowBadge: false,
          playSound: false,
          enableVibration: true,
          onlyAlertOnce: true,
        ),
      ],
      debug: kDebugMode,
    );

    // Request permission if not granted (Android 13+/iOS)
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> showSuccess(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        backgroundColor: const Color(0xFF2E7D32),
        color: Colors.white,
        displayOnForeground: true,
        displayOnBackground: true,
        autoDismissible: true,
        wakeUpScreen: true,
        category: NotificationCategory.Status,
      ),
    );
  }

  static Future<void> showInfo(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        backgroundColor: const Color(0xFF1976D2),
        color: Colors.white,
        displayOnForeground: true,
        displayOnBackground: true,
        autoDismissible: true,
        wakeUpScreen: true,
        category: NotificationCategory.Status,
      ),
    );
  }

  static Future<void> showError(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: _channelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
        backgroundColor: const Color(0xFFB00020),
        color: Colors.white,
        displayOnForeground: true,
        displayOnBackground: true,
        autoDismissible: true,
        wakeUpScreen: true,
        category: NotificationCategory.Error,
      ),
    );
  }
}
