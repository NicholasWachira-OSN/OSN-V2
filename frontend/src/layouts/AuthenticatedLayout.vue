<template>
  <div class="min-h-screen app-bg-gradient text-gray-900 dark:text-white">
    <!-- Top Navigation -->
    <nav class="sticky top-0 nav-gloss border-b border-gray-300 dark:border-gray-700 z-40">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-16">
          <!-- Logo -->
          <div class="flex items-center flex-shrink-0">
            <router-link to="/dashboard" class="flex items-center !bg-transparent">
              <img 
                :src="isDark ? '/osn-w.png' : '/osn-d.png'" 
                alt="WoopySport" 
                class="h-12 w-auto object-contain" 
              />
            </router-link>
          </div>

          <!-- Desktop Navigation Links -->
          <div class="hidden md:flex items-center space-x-6">
            <router-link
              to="/home"
              class="text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Home
            </router-link>
            <router-link
              to="/dashboard"
              class="text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Dashboard
            </router-link>
            <router-link
              to="/videos"
              class="text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Watch
            </router-link>
            <router-link
              to="/browse"
              class="text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white px-3 py-2 rounded-md text-sm font-medium transition-colors"
            >
              Browse
            </router-link>
          </div>

          <!-- Right Side: Dark Mode + User Menu -->
          <div class="hidden md:flex items-center space-x-4">
            <!-- Dark Mode Toggle -->
            <button
              @click="handleToggleDark"
              class="p-2 rounded-lg hover:bg-gray-300 dark:hover:bg-white/10 transition-colors"
              :title="isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'"
            >
              <svg
                v-if="isDark"
                class="w-5 h-5 text-yellow-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"
                />
              </svg>
              <svg
                v-else
                class="w-5 h-5 text-gray-700"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"
                />
              </svg>
            </button>

            <!-- User Info -->
            <span class="text-gray-700 dark:text-gray-300 text-sm">{{ user?.name || 'User' }}</span>

            <!-- Logout Button -->
            <button
              @click="handleLogout"
              class="px-4 py-2 bg-red-500 hover:bg-red-600 text-white rounded-md text-sm font-medium transition-colors"
            >
              Logout
            </button>
          </div>

          <!-- Mobile Menu Button -->
          <div class="md:hidden">
            <button
              @click="mobileMenuOpen = !mobileMenuOpen"
              class="p-2 rounded-md text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-300 dark:hover:bg-white/10 transition-colors"
            >
              <svg class="h-6 w-6" stroke="currentColor" fill="none" viewBox="0 0 24 24">
                <path
                  :class="{ hidden: mobileMenuOpen, 'inline-flex': !mobileMenuOpen }"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M4 6h16M4 12h16M4 18h16"
                />
                <path
                  :class="{ hidden: !mobileMenuOpen, 'inline-flex': mobileMenuOpen }"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M6 18L18 6M6 6l12 12"
                />
              </svg>
            </button>
          </div>
        </div>

        <!-- Mobile Menu -->
        <div v-show="mobileMenuOpen" class="md:hidden border-t border-gray-300 dark:border-gray-700 py-4">
          <div class="space-y-3">
            <router-link
              to="/dashboard"
              class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-300 dark:hover:bg-white/10 transition-colors"
              @click="mobileMenuOpen = false"
            >
              Dashboard
            </router-link>
            <router-link
              to="/videos"
              class="block px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-300 dark:hover:bg-white/10 transition-colors"
              @click="mobileMenuOpen = false"
            >
              Watch
            </router-link>

            <div class="border-t border-gray-300 dark:border-gray-700 pt-3 mt-3">
              <button
                @click="handleToggleDark"
                class="w-full text-left px-3 py-2 rounded-md text-base font-medium text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-300 dark:hover:bg-white/10 transition-colors"
              >
                {{ isDark ? '☀️ Light Mode' : '🌙 Dark Mode' }}
              </button>
              <button
                @click="handleLogout"
                class="w-full text-left px-3 py-2 rounded-md text-base font-medium text-red-400 hover:text-red-300 hover:bg-white/10 transition-colors mt-2"
              >
                Logout
              </button>
            </div>
          </div>
        </div>
      </div>
    </nav>

    <!-- Page Content -->
    <main class="overflow-hidden">
      <slot />
    </main>

    <!-- Footer -->
    <Footer />
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useDarkMode } from '@/composables/useDarkMode'
import Footer from '@/components/Footer.vue'

const router = useRouter()
const authStore = useAuthStore()
const { isDark, toggleDark } = useDarkMode()

const mobileMenuOpen = ref(false)
const user = computed(() => authStore.user)

// Debug wrapper for toggle
function handleToggleDark() {
  console.log('=== TOGGLE CLICKED ===')
  console.log('Before - isDark:', isDark.value)
  console.log('Before - HTML classes:', document.documentElement.className)
  console.log('Before - HTML bg color:', getComputedStyle(document.documentElement).backgroundColor)
  
  toggleDark()
  
  setTimeout(() => {
    console.log('After - isDark:', isDark.value)
    console.log('After - HTML classes:', document.documentElement.className)
    console.log('After - HTML bg color:', getComputedStyle(document.documentElement).backgroundColor)
    console.log('Expected: Light mode = rgb(238, 238, 238) | Dark mode = rgb(31, 31, 31)')
  }, 100)
}

async function handleLogout() {
  try {
    await authStore.logoutUser()
    router.push('/login')
  } catch (err) {
    console.error('Logout failed:', err)
    router.push('/login')
  }
}
</script>

<style scoped>
/* Gradient background for the entire app area */
.app-bg-gradient {
  min-height: 100vh;
}

/* Make nav slightly translucent + glossy so the gradient shows through */
.nav-gloss {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

:global(.dark) .nav-gloss {
  background: rgba(0, 0, 0, 0.2);
}

/* Active router link styling */
.router-link-active {
  background-color: rgba(147, 51, 234, 0.2);
  font-weight: 600;
}
</style>
