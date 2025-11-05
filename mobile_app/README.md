# woopysport_v2

Osn Mobile Application

## Getting Started

This project is a Flutter application for WoopySport v2 with Riverpod + GoRouter and Dio.

## Notifications

We use `awesome_notifications` for visible, reliable in-app notifications (login/register/logout success, etc.).

- Initialization: handled in `lib/main.dart` via `NotificationService.initialize()`.
- Channel: `basic_channel` defined in `lib/core/notifications/notification_service.dart`.
- Runtime permission: requested on first launch when needed (Android 13+ and iOS).

### Android setup

- Required permissions are declared in `android/app/src/main/AndroidManifest.xml`:
  - `POST_NOTIFICATIONS` (Android 13+)
  - `RECEIVE_BOOT_COMPLETED`, `VIBRATE`, `WAKE_LOCK`
- No additional receivers/services are needed; provided by the plugin.

### Windows development note

If you see "Building with plugins requires symlink support", enable Windows Developer Mode:
Settings > Privacy & Security > For developers > Developer Mode ON.

## Auth flows

- Token-based mobile auth against Laravel Sanctum endpoints.
- State: Riverpod `authProvider` in `lib/providers`.
- Routes: `GoRouter` in `lib/router/app_router.dart` with auth guards.

## Useful paths

- Notifications: `lib/core/notifications/notification_service.dart`
- Snackbars (fallback): `lib/core/ui/snackbar_service.dart`
- Screens: `lib/screens` (Login, Register, Home)
- Networking: `lib/core/network`, `lib/repositories`
