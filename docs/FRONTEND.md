# Frontend Documentation

## Overview

The frontend is a modern Single Page Application (SPA) built with Vue 3, providing the web interface for Woopysport v2.

## Tech Stack

- **Framework**: Vue 3 (Composition API)
- **Build Tool**: Vite
- **State Management**: Pinia
- **HTTP Client**: Axios
- **Routing**: Vue Router
- **Styling**: Tailwind CSS

## Architecture

### Authentication Strategy

- **Method**: Sanctum stateful sessions with cookies
- **Provider**: Laravel Fortify backend
- **Flow**: 
  1. Frontend proxies `/api` and `/sanctum/csrf-cookie` to backend via Vite
  2. Axios configured with `withCredentials: true`
  3. CSRF token automatically handled via cookies
  4. Session stored in backend database

### Directory Structure

```
frontend/
├── src/
│   ├── api/
│   │   └── auth.js           # Auth API calls
│   ├── stores/
│   │   └── auth.js           # Pinia auth store
│   ├── router/
│   │   └── index.js          # Vue Router + guards
│   ├── views/
│   │   ├── Login.vue
│   │   ├── Register.vue
│   │   └── Dashboard.vue
│   ├── components/
│   ├── App.vue
│   └── main.js
├── vite.config.js
└── package.json
```

## Configuration

### Vite Configuration (`vite.config.js`)

```javascript
export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
      '/sanctum/csrf-cookie': {
        target: 'http://localhost:8000',
        changeOrigin: true,
      },
    },
  },
});
```

### Axios Client

```javascript
import axios from 'axios';

const apiClient = axios.create({
  baseURL: '/api',  // Proxied via Vite
  withCredentials: true,
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
});

export default apiClient;
```

## State Management

### Auth Store (Pinia)

```javascript
import { defineStore } from 'pinia';
import { login, logout, getUser } from '@/api/auth';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    loading: false,
    error: null,
  }),
  
  getters: {
    isAuthenticated: (state) => !!state.user,
  },
  
  actions: {
    async login(credentials) {
      // Implementation
    },
    
    async logout() {
      // Implementation
    },
    
    async fetchUser() {
      // Implementation
    },
  },
});
```

## Routing

### Router Configuration

```javascript
import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const routes = [
  {
    path: '/login',
    component: () => import('@/views/Login.vue'),
    meta: { requiresGuest: true },
  },
  {
    path: '/dashboard',
    component: () => import('@/views/Dashboard.vue'),
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

// Navigation guard
router.beforeEach((to, from, next) => {
  const auth = useAuthStore();
  
  if (to.meta.requiresAuth && !auth.isAuthenticated) {
    next('/login');
  } else if (to.meta.requiresGuest && auth.isAuthenticated) {
    next('/dashboard');
  } else {
    next();
  }
});

export default router;
```

## API Integration

### Auth API Module

```javascript
import apiClient from './client';

// Get CSRF cookie before login/register
export const getCsrfCookie = () => {
  return apiClient.get('/sanctum/csrf-cookie');
};

export const login = async (email, password) => {
  await getCsrfCookie();
  return apiClient.post('/v2/login', { email, password });
};

export const register = async (name, email, password, password_confirmation) => {
  await getCsrfCookie();
  return apiClient.post('/v2/register', {
    name,
    email,
    password,
    password_confirmation,
  });
};

export const logout = () => {
  return apiClient.post('/v2/logout');
};

export const getUser = () => {
  return apiClient.get('/v2/user');
};
```

## Components

### Login Component Example

```vue
<template>
  <div class="login-container">
    <h1>Login</h1>
    <form @submit.prevent="handleLogin">
      <input v-model="email" type="email" placeholder="Email" required />
      <input v-model="password" type="password" placeholder="Password" required />
      <button type="submit" :disabled="loading">Login</button>
    </form>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();
const authStore = useAuthStore();

const email = ref('');
const password = ref('');
const loading = ref(false);
const error = ref(null);

const handleLogin = async () => {
  loading.value = true;
  error.value = null;
  
  try {
    await authStore.login({
      email: email.value,
      password: password.value,
    });
    router.push('/dashboard');
  } catch (err) {
    error.value = err.response?.data?.message || 'Login failed';
  } finally {
    loading.value = false;
  }
};
</script>
```

## Setup

### Requirements
- Node.js 18+ or 20+
- npm or yarn or pnpm

### Installation

1. **Install dependencies:**
   ```bash
   cd frontend
   npm install
   ```

2. **Environment setup:**
   ```bash
   cp .env.example .env
   ```

3. **Configure `.env`:**
   ```env
   VITE_API_URL=http://localhost:8000
   ```

4. **Start development server:**
   ```bash
   npm run dev
   ```

   The app will be available at `http://localhost:5173`

5. **Build for production:**
   ```bash
   npm run build
   ```

## Development Workflow

### Running with Backend

1. Start backend server:
   ```bash
   cd backend
   php artisan serve --host=0.0.0.0 --port=8000
   ```

2. Start frontend dev server:
   ```bash
   cd frontend
   npm run dev
   ```

3. Access frontend at: `http://localhost:5173`

### Hot Module Replacement (HMR)

Vite provides instant hot reloading:
- Vue components update without page refresh
- State is preserved during updates
- CSS changes apply instantly

## Authentication Flow

### Login Flow
1. User visits `/login`
2. Form submission triggers `authStore.login()`
3. Frontend fetches CSRF cookie from `/sanctum/csrf-cookie`
4. POST to `/api/v2/login` with credentials
5. Backend sets session cookie
6. Frontend fetches user data from `/api/v2/user`
7. User redirected to `/dashboard`

### Session Restoration
1. App loads, checks if user is authenticated
2. If session cookie exists, fetch user from `/api/v2/user`
3. If successful, restore user state
4. If fails (401), clear state and redirect to login

### Logout Flow
1. User clicks logout button
2. POST to `/api/v2/logout`
3. Backend destroys session
4. Frontend clears user state
5. Redirect to `/login`

## Styling

### Tailwind CSS

```bash
# Install Tailwind
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

Configure `tailwind.config.js`:
```javascript
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## Troubleshooting

### CORS Errors
- **Issue**: `Access-Control-Allow-Origin` errors
- **Solution**: 
  - Verify Vite proxy configuration
  - Check backend CORS config includes frontend origin
  - Ensure `withCredentials: true` in Axios

### CSRF Token Mismatch
- **Issue**: 419 CSRF token mismatch
- **Solution**:
  - Call `/sanctum/csrf-cookie` before login/register
  - Verify `SESSION_SAME_SITE=lax` in backend `.env`
  - Check cookies are being sent with requests

### Session Not Persisting
- **Issue**: User logged out on page refresh
- **Solution**:
  - Verify `withCredentials: true` in Axios config
  - Check backend session driver is `database`
  - Ensure domains match in Sanctum config

### 401 Unauthorized
- **Issue**: API returns 401 after successful login
- **Solution**:
  - Verify session cookie is being sent
  - Check backend `stateful` domains include frontend URL
  - Inspect browser DevTools > Application > Cookies

## Next Steps

- [ ] Add loading states/skeletons
- [ ] Implement form validation library (Vuelidate/VeeValidate)
- [ ] Add toast notifications
- [ ] Create reusable form components
- [ ] Implement password reset UI
- [ ] Add email verification flow
- [ ] Set up error boundary
- [ ] Add dark mode support
