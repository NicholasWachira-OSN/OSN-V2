import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'core/ui/snackbar_service.dart';
import 'core/notifications/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeProvider);

    // SnackbarServices remains wired for app-wide snackbars via messengerKey

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Osn Mobile',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      scaffoldMessengerKey: SnackbarService.messengerKey,
      routerConfig: router,
    );
  }
}
