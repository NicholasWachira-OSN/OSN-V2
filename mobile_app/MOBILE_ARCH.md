# Mobile App Architecture

## Overview
Clean architecture Flutter app using:
- **Dio** for networking (interceptors, logging, error handling)
- **Provider** for state management
- **Sanctum Personal Access Tokens** for mobile auth
- **Secure Storage** for token persistence

## Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart          # Base URLs, endpoints, timeouts
│   ├── network/
│   │   ├── dio_client.dart          # Dio singleton with interceptors
│   │   └── dio_interceptor.dart     # Auto-inject Bearer token
│   └── errors/
│       └── api_exception.dart       # Unified error handling
├── models/
│   └── user.dart                     # User data model
├── repositories/
│   └── auth_repository.dart         # API calls (login, logout, getUser)
├── providers/
│   └── auth_provider.dart           # Auth state (ChangeNotifier)
├── services/
│   └── secure_storage.dart          # Token storage
├── screens/
│   ├── login_screen.dart            # Login UI
│   └── home_screen.dart             # Authenticated home
└── main.dart                         # App entry + AuthGate

```

## Key Features

### 1. Dio Client with Interceptors
- Auto-injects `Bearer <token>` on all requests
- Pretty logging in debug mode (see request/response bodies)
- Global error handling (401 auto-clears token)

### 2. API Exception Handling
- Converts Dio errors to readable messages
- Handles timeouts, connection errors, bad responses
- Extracts server error messages from JSON

### 3. Auth Flow
1. **Login**: POST /api/v2/mobile/login → saves token → fetches user
2. **Auto-restore**: On app start, if token exists → GET /api/v2/user
3. **Logout**: POST /api/v2/mobile/logout (revokes token) → clears local storage
4. **AuthGate**: Watches `isAuthenticated` → auto-navigates Login ↔ Home

### 4. Configuration
- `lib/core/config/api_config.dart`:
  - **Android Emulator**: `http://10.0.2.2:8000` (default)
  - **iOS Simulator**: `http://localhost:8000`
  - **Physical Device**: Change to your PC's LAN IP (e.g., `http://192.168.1.10:8000`)

## Backend Requirements

### Laravel Routes (already set up)
```php
// routes/api.php
Route::prefix('v2')->group(function () {
    Route::post('/mobile/login', [MobileAuthController::class, 'login']);
    Route::middleware('auth:sanctum')->post('/mobile/logout', [MobileAuthController::class, 'logout']);
    Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
        return new UserResource($request->user());
    });
});
```

### Expected API Responses

**POST /api/v2/mobile/login**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com"
  },
  "token": "1|abc123..."
}
```

**GET /api/v2/user** (with Bearer token)
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com"
}
```

## Running the App

1. **Start Backend**:
```bash
cd C:\xampp\htdocs\woopysport-v2\backend
php artisan serve --host=0.0.0.0 --port=8000
```

2. **Run Flutter**:
```bash
cd C:\xampp\htdocs\woopysport-v2\mobile_app
flutter run -d emulator-5554
```

3. **Test Login**:
   - Use credentials from your database
   - Watch console for pretty-printed API logs
   - On success, you'll auto-navigate to HomeScreen

## Debugging

- **Check logs**: All requests/responses printed in debug console
- **401 errors**: Token auto-cleared, user logged out
- **Connection timeout**: Check backend is running at correct URL
- **Physical device**: Update `api_config.dart` baseUrl to your PC's LAN IP

## Next Steps

- Add registration screen
- Implement refresh token flow (optional)
- Add form validation
- Error retry logic
- Offline mode detection
