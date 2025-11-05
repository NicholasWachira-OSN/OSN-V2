# Woopysport v2 Documentation

This project is a modern full-stack application split into three main components:

- **Backend**: Laravel 12 API + Filament Admin
- **Frontend**: Vue 3 SPA
- **Mobile App**: Flutter application

## Project Structure

```
woopysport-v2/
├── backend/           # Laravel 12 API + Filament
├── frontend/          # Vue 3 + Vite SPA
├── mobile_app/        # Flutter mobile app
└── docs/              # Documentation
```

## Quick Links

- [Backend Documentation](./BACKEND.md) - Laravel API, Sanctum, Fortify
- [Frontend Documentation](./FRONTEND.md) - Vue 3 SPA architecture
- [Mobile Documentation](./MOBILE.md) - Flutter app architecture

## Tech Stack Overview

### Backend
- Laravel 12 (PHP 8.2+)
- Laravel Sanctum (Authentication)
- Laravel Fortify (Web Auth)
- Filament Admin Panel
- MySQL Database

### Frontend
- Vue 3 (Composition API)
- Pinia (State Management)
- Vite (Build Tool)
- Axios (HTTP Client)
- Vue Router
- Tailwind CSS

### Mobile
- Flutter 3.24.3
- Dart 3.5.3
- Dio (HTTP Client)
- Provider (State Management)
- Flutter Secure Storage
- Clean Architecture Pattern

## Authentication Strategy

### Web SPA (Frontend)
- **Method**: Sanctum stateful sessions with cookies
- **Endpoints**: Fortify routes (`/login`, `/logout`, `/register`)
- **Flow**: Cookie-based CSRF protection

### Mobile App
- **Method**: Sanctum Personal Access Tokens (PATs)
- **Endpoints**: Mobile-specific API (`/api/v2/mobile/*`)
- **Flow**: Token-based authentication with Bearer headers

## Getting Started

See individual documentation files for detailed setup instructions:
- [Backend Setup](./BACKEND.md#setup)
- [Frontend Setup](./FRONTEND.md#setup)
- [Mobile Setup](./MOBILE.md#setup)

## Development Status

### Completed Features
- ✅ Backend API authentication (Sanctum + Fortify)
- ✅ Mobile authentication flow (login/logout/register)
- ✅ Mobile clean architecture implementation
- ✅ Logout confirmation dialog
- ✅ User registration flow

### In Progress
- 🚧 Frontend SPA development
- 🚧 Admin panel customization

### Planned
- 📋 Password reset flow
- 📋 Email verification
- 📋 Two-factor authentication
- 📋 Profile management

## License

[Add your license here]
