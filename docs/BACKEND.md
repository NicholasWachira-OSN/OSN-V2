# Backend Documentation

## Overview

The backend is built with Laravel 12 and provides:
- RESTful API for web and mobile clients
- Filament admin panel
- Authentication via Laravel Sanctum and Fortify
- Database-driven sessions

## Tech Stack

- **Framework**: Laravel 12
- **PHP Version**: 8.2+
- **Database**: MySQL
- **Authentication**: Laravel Sanctum + Fortify
- **Admin Panel**: Filament
- **Session Driver**: Database

## Architecture

### Authentication Strategy

#### Web SPA Authentication
- **Provider**: Laravel Fortify
- **Method**: Stateful session cookies
- **Guard**: `web`
- **Endpoints**: 
  - `POST /api/v2/login` (Fortify)
  - `POST /api/v2/logout` (Fortify)
  - `POST /api/v2/register` (Fortify)
  - `GET /api/v2/user` (Sanctum)

#### Mobile Authentication
- **Provider**: Custom MobileAuthController
- **Method**: Personal Access Tokens (PATs)
- **Guard**: `sanctum`
- **Endpoints**:
  - `POST /api/v2/mobile/login` - Returns `{user, token}`
  - `POST /api/v2/mobile/register` - Returns `{user, token}`
  - `POST /api/v2/mobile/logout` - Revokes token
  - `GET /api/v2/user` - Protected with Bearer token

### Directory Structure

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── V2/
│   │   │       └── Auth/
│   │   │           └── MobileAuthController.php
│   │   └── Resources/
│   │       └── V2/
│   │           └── UserResource.php
│   ├── Models/
│   │   └── User.php
│   └── Providers/
│       ├── AppServiceProvider.php
│       └── Filament/
├── config/
│   ├── sanctum.php
│   ├── fortify.php
│   ├── auth.php
│   └── session.php
├── routes/
│   ├── api.php          # API routes
│   └── web.php          # Web routes + compatibility
└── database/
    └── migrations/
        └── *_create_personal_access_tokens_table.php
```

## Configuration

### Sanctum (`config/sanctum.php`)

```php
'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', 
    'localhost,localhost:3000,localhost:5173,127.0.0.1,127.0.0.1:8000,::1'
)),

'guard' => ['web'],
```

### Fortify (`config/fortify.php`)

```php
'guard' => 'web',
'views' => false,  // API-only mode
'features' => [
    Features::registration(),
    Features::resetPasswords(),
    Features::emailVerification(),
    Features::updateProfileInformation(),
    Features::updatePasswords(),
    Features::twoFactorAuthentication([
        'confirm' => true,
        'confirmPassword' => true,
    ]),
],
```

### Session (`config/session.php`)

```php
'driver' => env('SESSION_DRIVER', 'database'),
'same_site' => env('SESSION_SAME_SITE', 'lax'),
```

## API Routes

### Mobile Authentication Routes

```php
// Public routes
POST /api/v2/mobile/login
POST /api/v2/mobile/register

// Protected routes (requires Bearer token)
POST /api/v2/mobile/logout
GET  /api/v2/user
```

### Request/Response Examples

#### Register (Mobile)
**Request:**
```http
POST /api/v2/mobile/register
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "SecurePass123",
  "password_confirmation": "SecurePass123"
}
```

**Response (201):**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2025-10-30T12:00:00.000000Z"
  },
  "token": "1|abc123def456..."
}
```

#### Login (Mobile)
**Request:**
```http
POST /api/v2/mobile/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "SecurePass123"
}
```

**Response (200):**
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "created_at": "2025-10-30T12:00:00.000000Z"
  },
  "token": "2|xyz789abc456..."
}
```

#### Get User
**Request:**
```http
GET /api/v2/user
Authorization: Bearer 2|xyz789abc456...
```

**Response (200):**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "created_at": "2025-10-30T12:00:00.000000Z"
}
```

#### Logout (Mobile)
**Request:**
```http
POST /api/v2/mobile/logout
Authorization: Bearer 2|xyz789abc456...
```

**Response (204):**
```
No content
```

## Models

### User Model

```php
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
```

## Setup

### Requirements
- PHP 8.2 or higher
- Composer
- MySQL 5.7+ or MariaDB 10.3+
- XAMPP or similar (Apache + MySQL)

### Installation

1. **Install dependencies:**
   ```bash
   cd backend
   composer install
   ```

2. **Environment setup:**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

3. **Configure `.env`:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=osn-v2
   DB_USERNAME=root
   DB_PASSWORD=

   SESSION_DRIVER=database
   SESSION_SAME_SITE=lax
   
   SANCTUM_STATEFUL_DOMAINS=localhost:5173,localhost:8000,127.0.0.1:5173,127.0.0.1:8000
   ```

4. **Run migrations:**
   ```bash
   php artisan migrate
   ```

5. **Publish Sanctum migrations (if needed):**
   ```bash
   php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
   php artisan migrate
   ```

6. **Start development server:**
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```

### Testing Routes

```bash
# List all API routes
php artisan route:list --path=api/v2

# Check migration status
php artisan migrate:status

# Debug session info
php artisan route:list --path=debug
```

## Security Considerations

### CORS
- Configured for local development (localhost/127.0.0.1)
- Update for production domains in `config/cors.php`

### Rate Limiting
- Consider adding rate limiting to auth endpoints
- Use Laravel's built-in throttle middleware

### Password Validation
- Enforces Laravel's Password::defaults() rules
- Requires password confirmation on registration

### Token Management
- Mobile tokens are revoked on logout
- Tokens stored in `personal_access_tokens` table
- Consider implementing token expiration

## Troubleshooting

### CSRF Token Mismatch
- **Issue**: Mobile clients getting CSRF errors
- **Solution**: Use `/api/v2/mobile/*` endpoints (no CSRF required)

### 401 Unauthorized
- **Issue**: Token not being accepted
- **Solution**: 
  - Verify token format: `Authorization: Bearer <token>`
  - Check token exists in `personal_access_tokens` table
  - Ensure `HasApiTokens` trait on User model

### Session Not Persisting
- **Issue**: Web SPA losing authentication
- **Solution**:
  - Verify `SESSION_DRIVER=database` in `.env`
  - Check `stateful` domains in `config/sanctum.php`
  - Ensure `withCredentials: true` in frontend Axios

## Next Steps

- [ ] Implement email verification
- [ ] Add password reset flow
- [ ] Configure 2FA
- [ ] Add API rate limiting
- [ ] Set up proper CORS for production
- [ ] Implement token expiration/refresh
