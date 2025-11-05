// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider_riverpod.dart';
import '../providers/theme_provider.dart';
import '../core/auth/auth_flow.dart';
import '../shared/widgets/primary_side_bar.dart';
import '../shared/widgets/footer_section.dart';

class WatchScreen extends ConsumerWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;
    final logo = isDark ? 'assets/images/osn-w.png' : 'assets/images/osn-d.png';
  final isLoggedIn = ref.watch(authProvider).isAuthenticated;

    return Scaffold(
      drawer: const PrimarySideBar(currentPath: '/watch'),
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => context.go('/'),
          child: Image.asset(logo, height: 40),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          ),
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && context.mounted) {
                  await AuthFlow.runLogout(
                    context: context,
                    logoutAction: () => ref.read(authProvider.notifier).logout(),
                    navigateTo: '/login',
                  );
                }
              },
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: const [
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Watch page (coming soon)'),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(child: FooterSection()),
          SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
