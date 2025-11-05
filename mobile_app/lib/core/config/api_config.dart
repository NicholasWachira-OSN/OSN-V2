import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URL configuration
  // Android Emulator: use 10.0.2.2 for host machine localhost
  // iOS Simulator: use localhost or 127.0.0.1
  // Physical Device: use your PC's LAN IP (e.g., 192.168.1.10)
  static String get baseUrl {
    // Allow override at run-time via --dart-define=BASE_URL=http://<host>:<port>
    const envBase = String.fromEnvironment('BASE_URL');
    if (envBase.isNotEmpty) return envBase;

    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // Default for emulators; for physical devices pass BASE_URL via --dart-define
    return 'http://10.0.2.2:8000';
  }

  // API endpoints
  static const String mobileLogin = '/api/v2/mobile/login';
  static const String mobileLogout = '/api/v2/mobile/logout';
  static const String register = '/api/v2/mobile/register';
  static const String getUser = '/api/v2/user';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
