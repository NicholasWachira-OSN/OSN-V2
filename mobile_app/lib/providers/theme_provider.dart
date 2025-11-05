import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/theme_service.dart';

// Theme service provider
final themeServiceProvider = Provider<ThemeService>((ref) {
  return ThemeService();
});

// Theme notifier to manage theme state
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService) : super(ThemeMode.system) {
    _loadTheme();
  }

  // Load saved theme on initialization
  Future<void> _loadTheme() async {
    final savedTheme = await _themeService.loadThemeMode();
    state = savedTheme;
  }

  // Set theme and persist it
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _themeService.saveThemeMode(mode);
  }

  // Toggle between light and dark (ignoring system for simplicity)
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});
