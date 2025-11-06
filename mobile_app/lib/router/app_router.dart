import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider_riverpod.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/watch_screen.dart';
import '../screens/browse_screen.dart';
import '../screens/features_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/video_screen.dart';
import '../features/reels/screens/reels_viewer_screen.dart';

// GoRouter provider
final goRouterProvider = Provider<GoRouter>((ref) {
  // Keep auth provider warm for UI that reacts to auth state (e.g., drawer)
  ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    // Disable verbose route logs to avoid noisy console output
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginScreen(
          from: state.uri.queryParameters['from'],
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => RegisterScreen(
          from: state.uri.queryParameters['from'],
        ),
      ),
      GoRoute(
        path: '/video',
        name: 'video',
        builder: (context, state) {
          final url = state.uri.queryParameters['url'];
          final title = state.uri.queryParameters['title'];
          final poster = state.uri.queryParameters['poster'];
          return VideoScreen(url: url, title: title, poster: poster);
        },
      ),
      GoRoute(
        path: '/watch',
        name: 'watch',
        builder: (context, state) => const WatchScreen(),
      ),
      GoRoute(
        path: '/browse',
        name: 'browse',
        builder: (context, state) => const BrowseScreen(),
      ),
      GoRoute(
        path: '/features',
        name: 'features',
        builder: (context, state) => const FeaturesScreen(),
      ),
      GoRoute(
        path: '/schedule',
        name: 'schedule',
        builder: (context, state) => const ScheduleScreen(),
      ),
      GoRoute(
        path: '/reels',
        name: 'reels',
        builder: (context, state) {
          final idxStr = state.uri.queryParameters['index'];
          final idx = int.tryParse(idxStr ?? '') ?? 0;
          return ReelsViewerScreen(initialIndex: idx);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: $state.matchedLocation'),
      ),
    ),
  );
});
