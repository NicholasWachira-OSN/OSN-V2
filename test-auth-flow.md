# Auth Flow Testing Guide

## Prerequisites
- Backend running on `http://localhost:8000`
- Frontend running on `http://localhost:5173`
- Database configured and migrated
- At least one test user created (or use register)

## Test Flow

### 1. Test Login & Session Persistence
1. **Navigate to Login**
   - Open browser: `http://localhost:5173/login`
   - Open DevTools (F12) → Network tab → Preserve log
   
2. **Login**
   - Enter credentials (or register first)
   - Submit form
   - **Expected:**
     - Network shows:
       - GET `sanctum/csrf-cookie` → 204 No Content
       - POST `api/v2/login` → 200 OK with user data
       - GET `sanctum/csrf-cookie` → 204 No Content (CSRF refresh)
     - Cookies set:
       - `XSRF-TOKEN` (visible in Application → Cookies)
       - `laravel_session` (httpOnly, so won't see value but should exist)
     - Redirects to `/dashboard`
     - User name and email displayed

3. **Check Pinia State**
   - Open Vue DevTools → Pinia tab
   - **Expected:**
     - `auth` store shows:
       - `user`: { id, name, email, created_at }
       - `isAuthenticated`: true

4. **Test Session Persistence (Hard Refresh)**
   - Press `Ctrl+Shift+R` or `F5` to hard refresh
   - **Expected:**
     - Page reloads
     - Network shows:
       - GET `api/v2/user` → 200 OK (from main.js fetchUser)
     - Dashboard still displays user info
     - User NOT redirected to login
     - Pinia store still has user data

5. **Test Session Persistence (New Tab)**
   - Open new tab, navigate to `http://localhost:5173/dashboard`
   - **Expected:**
     - Dashboard loads immediately
     - User data displayed
     - No redirect to login

### 2. Test Logout
1. **Click Logout Button**
   - On dashboard, click "Logout" button
   - **Expected:**
     - Network shows:
       - GET `sanctum/csrf-cookie` → 204 No Content (pre-logout CSRF refresh)
       - POST `api/v2/logout` → 204 No Content
     - Pinia store cleared:
       - `user`: null
       - `isAuthenticated`: false
     - Redirects to `/login`
     - Session cookies remain but invalidated server-side

2. **Verify Logout**
   - Try navigating to `http://localhost:5173/dashboard`
   - **Expected:**
     - Router guard redirects to `/login`
     - Network shows GET `api/v2/user` → 401 Unauthorized

3. **Verify Server Session**
   - In backend, check `sessions` table:
     ```bash
     php artisan tinker
     DB::table('sessions')->get()
     ```
   - Old session should be invalidated (different ID after logout)

### 3. Test Backend Session in Database

Check sessions table:
```bash
cd backend
php artisan tinker
```

```php
// Check active sessions
DB::table('sessions')->select('id', 'user_id', 'last_activity')->get()

// After login, should see entry with user_id
// After logout, session ID changes and user_id is null
```

## Expected Behavior Summary

| Action | Frontend State | Backend Session | Cookies |
|--------|---------------|-----------------|---------|
| **Login** | User stored in Pinia | Session with user_id | laravel_session + XSRF-TOKEN set |
| **Refresh** | User restored from /api/v2/user | Same session | Same cookies sent |
| **Logout** | User cleared from Pinia | Session invalidated, new ID | Session cookie updated |
| **After Logout** | Redirects to login | No user_id in session | Old session invalid |

## Troubleshooting

### Login doesn't persist on refresh
- Check: `SESSION_DRIVER=database` in .env
- Check: `sessions` table exists (run migrations)
- Check: Cookies are being sent (DevTools → Application → Cookies)
- Check: CORS allows credentials (`supports_credentials: true`)
- Check: Frontend sends `withCredentials: true` on all API requests

### Logout returns 500
- Check: User model has `use HasApiTokens` trait
- Check: LogoutController has defensive check for `currentAccessToken()`
- Check: `storage/logs/laravel.log` for stack trace

### CSRF token mismatch
- Check: `SANCTUM_STATEFUL_DOMAINS` includes `localhost:5173`
- Check: Frontend fetches `/sanctum/csrf-cookie` before auth requests
- Check: axios client sets `X-XSRF-TOKEN` from cookie
- Clear cache: `php artisan config:cache`

### Session not storing user_id
- Check: Route has `middleware(['web'])` wrapper for SPA endpoints
- Check: Route has `middleware('auth:sanctum')` for protected endpoints
- Check: LoginController calls `$request->session()->regenerate()` after Auth::attempt()

## Success Criteria

✅ User can login and see dashboard
✅ Hard refresh keeps user logged in (fetches from /api/v2/user)
✅ New tab shows dashboard without re-login
✅ Sessions table shows user_id after login
✅ Logout returns 204 and clears Pinia state
✅ After logout, dashboard redirects to login
✅ After logout, /api/v2/user returns 401
