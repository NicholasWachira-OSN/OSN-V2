import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import { useAuthStore } from './stores/auth'
import './assets/main.css'

// Async initialization to restore session before router
async function initApp() {
  const app = createApp(App)

  app.use(createPinia())

  // Try to restore session BEFORE router is installed
  const auth = useAuthStore()
  await auth.fetchUser()

  app.use(router)
  app.mount('#app')
}

initApp()
