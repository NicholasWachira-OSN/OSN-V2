# Mobile App Documentation

## Overview

The mobile application is built with Flutter 3.24.3 and provides native Android/iOS apps for Woopysport v2. It uses a clean architecture pattern with Sanctum Personal Access Tokens for authentication.

## Tech Stack

- **Framework**: Flutter 3.24.3
- **Language**: Dart 3.5.3
- **HTTP Client**: Dio 5.9.0
- **State Management**: Provider 6.1.2
- **Storage**: flutter_secure_storage 9.2.2
- **Logging**: pretty_dio_logger 1.4.0

## Architecture

### Clean Architecture Layers

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart         # API endpoints & timeouts
│   ├── network/
│   │   ├── dio_client.dart         # Dio singleton
│   │   └── dio_interceptor.dart    # Auth interceptor
│   └── errors/
│       └── api_exception.dart      # Unified error handling
├── models/
│   └── user.dart                   # User model
├── repositories/
│   └── auth_repository.dart        # API data layer
├── providers/
│   └── auth_provider.dart          # State management
├── services/
│   └── secure_storage.dart         # Token storage
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   └── home_screen.dart
└── main.dart                       # App entry point
```

### Authentication Strategy

- **Method**: Sanctum Personal Access Tokens (PATs)
- **Storage**: Flutter Secure Storage (encrypted keychain/keystore)
- **Flow**:
  1. Login/Register returns `{user, token}`
  2. Token saved to secure storage
  3. DioInterceptor auto-injects `Authorization: Bearer <token>` on all requests
  4. On 401, interceptor clears token and redirects to login
  5. Logout revokes token server-side

## Core Components

### API Configuration

**File**: `lib/core/config/api_config.dart`

```dart
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // Android Emulator uses 10.0.2.2 for host machine localhost
    // iOS Simulator uses localhost or 127.0.0.1
    // Physical device needs your PC's LAN IP
    return 'http://10.0.2.2:8000';
  }

  static const String mobileLogin = '/api/v2/mobile/login';
  static const String mobileLogout = '/api/v2/mobile/logout';
  static const String register = '/api/v2/mobile/register';
  static const String getUser = '/api/v2/user';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### Dio Client

**File**: `lib/core/network/dio_client.dart`

```dart
class DioClient {
  static DioClient? _instance;
  late Dio _dio;

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());

    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
      ));
    }
  }

  static DioClient get instance {
    _instance ??= DioClient._();
    return _instance!;
  }

  Dio get dio => _dio;
}
```

### Auth Interceptor

**File**: `lib/core/network/dio_interceptor.dart`

```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      SecureStorage.clearToken();
    }
    handler.next(err);
  }
}
```

### Error Handling

**File**: `lib/core/errors/api_exception.dart`

```dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Connection timeout');
      
      case DioExceptionType.badResponse:
        final response = error.response;
        final data = response?.data;
        
        if (data is Map<String, dynamic>) {
          return ApiException(
            message: data['message'] ?? 'Request failed',
            statusCode: response?.statusCode,
          );
        }
        return ApiException(
          message: 'Request failed with status ${response?.statusCode}',
          statusCode: response?.statusCode,
        );
      
      default:
        return ApiException(message: 'Network error occurred');
    }
  }
}
```

## Data Layer

### Auth Repository

**File**: `lib/repositories/auth_repository.dart`

```dart
class AuthRepository {
  final Dio _dio = DioClient.instance.dio;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.mobileLogin,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;

      if (token == null || token.isEmpty) {
        throw ApiException(message: 'No token received');
      }

      await SecureStorage.saveToken(token);
      return UserModel.fromJson(data['user']);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    // Similar implementation
  }

  Future<UserModel> getUser() async {
    // Fetch authenticated user
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.mobileLogout);
    } catch (_) {
      // Ignore errors
    } finally {
      await SecureStorage.clearToken();
    }
  }
}
```

## State Management

### Auth Provider

**File**: `lib/providers/auth_provider.dart`

```dart
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> init() async {
    // Restore session from secure storage
  }

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await _repo.login(email: email, password: password);
    } on ApiException catch (e) {
      _error = e.message;
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register({...}) async {
    // Similar to login
  }

  Future<void> logout() async {
    // Clear user and token
  }
}
```

## UI Layer

### Login Screen

**File**: `lib/screens/login_screen.dart`

Features:
- Form validation (email format, password length)
- Loading states
- Error handling with SnackBars
- Navigation to RegisterScreen
- Keyboard-aware scrolling

### Register Screen

**File**: `lib/screens/register_screen.dart`

Features:
- Name, email, password, confirm password fields
- Client-side validation
- Password match validation
- Auto-login after successful registration
- Error feedback

### Home Screen

**File**: `lib/screens/home_screen.dart`

Features:
- Display user information
- Logout button with confirmation dialog
- Protected by authentication guard

## Setup

### Requirements

- Flutter SDK 3.24.3+
- Dart SDK 3.5.3+
- Android Studio (for Android development)
- Xcode (for iOS development, macOS only)
- Android NDK 27.2.12479018 (or compatible)

### Installation

1. **Clone and navigate:**
   ```bash
   cd mobile_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint:**
   
   Edit `lib/core/config/api_config.dart`:
   - **Android Emulator**: Use `http://10.0.2.2:8000`
   - **iOS Simulator**: Use `http://localhost:8000`
   - **Physical Device**: Use your PC's LAN IP (e.g., `http://192.168.1.10:8000`)

4. **Run the app:**
   
   Android Emulator:
   ```bash
   flutter run -d emulator-5554
   ```
   
   iOS Simulator:
   ```bash
   flutter run -d "iPhone 15"
   ```
   
   Physical device:
   ```bash
   flutter devices  # List devices
   flutter run -d <device-id>
   ```

### Backend Setup

Ensure the Laravel backend is running:
```bash
cd backend
php artisan serve --host=0.0.0.0 --port=8000
```

## Development

### Hot Reload

Flutter supports hot reload during development:
- `r` - Hot reload (preserves state)
- `R` - Hot restart (resets state)
- `q` - Quit

### Debug Logging

The app uses `PrettyDioLogger` in debug mode:
- All HTTP requests/responses are logged to console
- Includes headers, bodies, and timing
- Only enabled in debug builds

Example console output:
```
╔══════════════════════════════════════════
║ POST /api/v2/mobile/login
╟──────────────────────────────────────────
║ Headers:
║   Accept: application/json
║   Content-Type: application/json
╟──────────────────────────────────────────
║ Body:
║   {"email":"user@example.com","password":"..."}
╠══════════════════════════════════════════
║ 200 OK (245ms)
║ {"user":{...},"token":"..."}
╚══════════════════════════════════════════
```

### Static Analysis

Run Flutter analyzer:
```bash
flutter analyze
```

### Testing

Run tests:
```bash
flutter test
```

## Build & Release

### Android

1. **Configure signing:**
   - Create `android/key.properties`
   - Generate keystore
   - Update `android/app/build.gradle`

2. **Build APK:**
   ```bash
   flutter build apk --release
   ```

3. **Build App Bundle (for Play Store):**
   ```bash
   flutter build appbundle --release
   ```

### iOS

1. **Configure signing:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Set team and bundle identifier

2. **Build IPA:**
   ```bash
   flutter build ipa --release
   ```

## Authentication Flow

### Login Flow
1. User enters email & password
2. App calls `POST /api/v2/mobile/login`
3. Backend validates credentials
4. Backend returns `{user, token}`
5. App saves token to secure storage
6. App updates provider state
7. AuthGate redirects to HomeScreen

### Registration Flow
1. User fills registration form
2. App validates passwords match
3. App calls `POST /api/v2/mobile/register`
4. Backend creates user and returns `{user, token}`
5. App saves token and sets user state
6. User is automatically logged in

### Session Restoration
1. App launches
2. AuthProvider.init() checks secure storage
3. If token exists, calls `GET /api/v2/user`
4. If successful, restores user state
5. If fails (401), clears token and shows login

### Logout Flow
1. User taps logout → confirmation dialog
2. On confirm, calls `POST /api/v2/mobile/logout`
3. Backend revokes token
4. App clears secure storage
5. Provider clears user state
6. AuthGate redirects to LoginScreen

## Troubleshooting

### Connection Refused (Android Emulator)
- **Issue**: Can't connect to `localhost:8000`
- **Solution**: Use `10.0.2.2:8000` (emulator's gateway to host machine)

### SSL/HTTPS Issues
- **Issue**: HTTPS not working in development
- **Solution**: Use HTTP in development, implement SSL pinning for production

### Token Not Being Sent
- **Issue**: 401 errors despite successful login
- **Solution**:
  - Check `AuthInterceptor` is added to Dio
  - Verify token is saved in secure storage
  - Check Bearer format in headers

### Build Errors (Android)
- **NDK Version Mismatch**: Update `android/app/build.gradle` to match installed NDK
- **Java Version**: Ensure Java 17+ with Android Gradle Plugin 8.3.0
- **Gradle Cache**: Run `flutter clean && flutter pub get`

### State Not Updating
- **Issue**: UI not reflecting provider changes
- **Solution**:
  - Ensure `notifyListeners()` is called
  - Use `context.watch<AuthProvider>()` in build
  - Check widget is wrapped in Provider

## Security Considerations

### Token Storage
- Uses `flutter_secure_storage` (iOS Keychain / Android Keystore)
- Tokens encrypted at rest
- Auto-cleared on 401 responses

### Best Practices
- Never log tokens in production
- Implement token expiration
- Use HTTPS in production
- Add certificate pinning for sensitive apps
- Implement biometric authentication

## Performance Optimization

### Network
- Dio connection pooling enabled
- Request/response compression
- Timeout configurations prevent hanging

### State Management
- Provider only rebuilds listening widgets
- Minimal state exposure (private fields)
- Efficient `notifyListeners()` placement

### Build Size
- Remove unused dependencies
- Use code splitting for large apps
- Enable ProGuard/R8 for Android release

## Next Steps

- [ ] Add biometric authentication
- [ ] Implement token refresh mechanism
- [ ] Add offline mode support
- [ ] Create custom loading/error widgets
- [ ] Add deep linking
- [ ] Implement push notifications
- [ ] Add analytics/crash reporting
- [ ] Create CI/CD pipeline
- [ ] Add integration tests
- [ ] Implement proper app icons and splash screens
