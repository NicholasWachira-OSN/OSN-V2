<template>
  <GuestLayout>
    <template #default>
      <h2 class="text-3xl font-bold text-center mb-8 text-white">Login</h2>
      
      <form @submit.prevent="handleLogin" class="space-y-6">
        <div v-if="error" class="p-4 bg-red-500/20 text-red-300 rounded-lg border border-red-500/30">
          {{ error }}
        </div>

        <div>
          <label class="block text-gray-300 text-sm font-semibold mb-2" for="email">
            Email
          </label>
          <input
            id="email"
            v-model="form.email"
            type="email"
            required
            class="input"
            placeholder="your@email.com"
          />
        </div>

        <div>
          <label class="block text-gray-300 text-sm font-semibold mb-2" for="password">
            Password
          </label>
          <input
            id="password"
            v-model="form.password"
            type="password"
            required
            class="input"
            placeholder="••••••••"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="btn-primary w-full disabled:opacity-50"
        >
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
    </template>

    <template #footer>
      <p class="text-center text-gray-300 text-sm">
        Don't have an account?
        <router-link 
          to="/register" 
          class="text-primary-400 hover:text-primary-300 font-semibold transition-colors"
        >
          Register here
        </router-link>
      </p>
    </template>
  </GuestLayout>
</template>

<script setup>
defineOptions({ name: 'LoginView' })
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import GuestLayout from '@/layouts/GuestLayout.vue'

const router = useRouter()
const authStore = useAuthStore()

const form = ref({
  email: '',
  password: ''
})

const loading = ref(false)
const error = ref('')

async function handleLogin() {
  loading.value = true
  error.value = ''

  try {
    await authStore.loginUser(form.value)
    router.push('/dashboard')
  } catch (err) {
    error.value = err.response?.data?.message || 'Login failed. Please check your credentials.'
  } finally {
    loading.value = false
  }
}
</script>
