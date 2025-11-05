# Vue Frontend Debug Checklist

## Current Setup Status ✅

### Files Created/Updated
- ✅ `src/layouts/AuthenticatedLayout.vue` - Complete with gradient background
- ✅ `src/layouts/GuestLayout.vue` - Complete with glassmorphism
- ✅ `src/views/Dashboard.vue` - Using AuthenticatedLayout
- ✅ `src/views/Login.vue` - Using GuestLayout  
- ✅ `src/views/Register.vue` - Using GuestLayout
- ✅ `src/composables/useDarkMode.js` - VueUse dark mode composable
- ✅ `src/assets/main.css` - Tailwind directives + custom components
- ✅ `tailwind.config.js` - Configured with dark mode
- ✅ `postcss.config.js` - Configured for Tailwind

### Dependencies Installed
- ✅ @vueuse/core: ^14.0.0
- ✅ tailwindcss: ^4.1.16
- ✅ postcss: ^8.5.6
- ✅ autoprefixer: ^10.4.21
- ✅ vue: ^3.5.22
- ✅ vue-router: ^4.6.3
- ✅ pinia: ^3.0.3

## Troubleshooting Steps

### Step 1: Install Dependencies
```powershell
cd c:\xampp\htdocs\woopysport-v2\frontend
npm install
```

### Step 2: Start Dev Server
```powershell
npm run dev
```

Expected output:
```
VITE v7.x.x  ready in xxx ms
➜  Local:   http://localhost:5173/
➜  Network: use --host to expose
```

### Step 3: Open Browser
Navigate to: `http://localhost:5173/`

### Step 4: Check Browser Console
Press F12 and look for:
- ❌ Module not found errors
- ❌ 404 errors for assets
- ❌ Vue warnings
- ✅ No errors = working correctly

### Step 5: Test Routes
1. `/login` - Should show GuestLayout with gradient background
2. `/register` - Should show GuestLayout with centered form
3. `/dashboard` - Should show AuthenticatedLayout with navbar (requires login)

## Common Issues & Solutions

### Issue: White/Blank Screen
**Solution:**
```powershell
# Clear node_modules and reinstall
rm -r node_modules
rm package-lock.json
npm install
```

### Issue: Tailwind Styles Not Applying
**Solution:**
1. Check `main.js` imports `./assets/main.css`
2. Verify `tailwind.config.js` content paths include your Vue files
3. Restart dev server

### Issue: Dark Mode Not Working
**Solution:**
1. Check browser localStorage for `theme-mode` key
2. Verify `useDarkMode.js` is being imported
3. Check `<html>` element for `dark` class in browser inspector

### Issue: Routes Not Found
**Solution:**
1. Check `router/index.js` has all routes defined
2. Verify component imports are correct
3. Check auth guard logic in router

### Issue: Components Not Rendering
**Solution:**
1. Check component imports use correct paths (`@/` alias)
2. Verify all components have `<template>` and `<script setup>`
3. Look for syntax errors in browser console

## File Structure Verification

```
frontend/
├── src/
│   ├── layouts/
│   │   ├── AuthenticatedLayout.vue    ✅
│   │   └── GuestLayout.vue            ✅
│   ├── views/
│   │   ├── Dashboard.vue              ✅
│   │   ├── Login.vue                  ✅
│   │   └── Register.vue               ✅
│   ├── composables/
│   │   └── useDarkMode.js             ✅
│   ├── assets/
│   │   └── main.css                   ✅
│   ├── router/
│   │   └── index.js                   ✅
│   ├── stores/
│   │   └── auth.js                    ✅
│   ├── App.vue                        ✅
│   └── main.js                        ✅
├── tailwind.config.js                 ✅
├── postcss.config.js                  ✅
└── package.json                       ✅
```

## Expected Visual Results

### Login/Register Pages (GuestLayout)
- ✅ Gradient background (dark gray to lighter gray)
- ✅ Centered white/translucent card with glassmorphism
- ✅ Form inputs with dark mode support
- ✅ Purple primary buttons
- ✅ Footer with navigation links

### Dashboard (AuthenticatedLayout)
- ✅ Gradient background matching guest pages
- ✅ Sticky top navbar with glass effect
- ✅ "WoopySport V2" logo/brand
- ✅ Navigation links (Dashboard, Watch, Browse)
- ✅ Dark mode toggle button (sun/moon icon)
- ✅ User name display
- ✅ Logout button
- ✅ Mobile hamburger menu
- ✅ Stats cards with icons
- ✅ Recent activity list
- ✅ Footer at bottom

## Quick Test Commands

### Check if server is running
```powershell
# Check if port 5173 is in use
netstat -an | findstr "5173"
```

### View build output
```powershell
npm run build
```

### Preview production build
```powershell
npm run preview
```

## Browser DevTools Inspection

### Check HTML Structure
1. Open DevTools (F12)
2. Look for `<html class="dark">` when dark mode is on
3. Verify gradient classes on root div
4. Check if Tailwind classes are applied

### Check Network Tab
1. Verify all JS/CSS files load (200 status)
2. Check API calls to backend
3. Look for CORS errors if backend isn't connecting

### Check Console
Look for Vue warnings like:
- "Component is missing template"
- "Failed to resolve component"
- "Unknown custom element"

## Next Steps

1. **Run dev server**: `npm run dev`
2. **Open browser**: http://localhost:5173
3. **Test navigation**: Try all routes
4. **Test dark mode**: Click sun/moon toggle
5. **Test responsive**: Resize browser window
6. **Check mobile menu**: Click hamburger on small screen

## Contact Backend

Ensure backend is running for authentication:
```powershell
cd c:\xampp\htdocs\woopysport-v2\backend
php artisan serve
```

Default backend URL: `http://localhost:8000`

---

**Status**: All files created and configured correctly ✅  
**Ready to run**: Yes ✅  
**Next action**: Start dev server and test in browser
