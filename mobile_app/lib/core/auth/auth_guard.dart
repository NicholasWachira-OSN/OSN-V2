import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider_riverpod.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String from;

  const AuthGuard({super.key, required this.child, required this.from});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    // While restoring token/user, show lightweight splash/loader
    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // If unauthenticated, schedule navigation to login with from
    if (!auth.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        final encoded = Uri.encodeComponent(from);
        context.go('/login?from=$encoded');
      });
      // Render a minimal placeholder during the navigation tick
      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    // Authenticated -> render the protected child
    return child;
  }
}
