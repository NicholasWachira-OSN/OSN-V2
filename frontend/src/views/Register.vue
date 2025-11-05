<template>
  <GuestLayout>
    <template #default>
      <h2 class="text-3xl font-bold text-center mb-8 text-white">Register</h2>
      
      <form @submit.prevent="handleRegister" class="space-y-6">
        <div v-if="error" class="p-4 bg-red-500/20 text-red-300 rounded-lg border border-red-500/30">
          {{ error }}
        </div>

        <div v-if="success" class="p-4 bg-green-500/20 text-green-300 rounded-lg border border-green-500/30">
          Registration successful! Redirecting to login...
        </div>

        <div>
          <label class="block text-gray-300 text-sm font-semibold mb-2" for="name">
            Name
          </label>
          <input
            id="name"
            v-model="form.name"
            type="text"
            required
            class="input"
            placeholder="John Doe"
          />
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
            minlength="8"
            class="input"
            placeholder="••••••••"
          />
        </div>

        <div>
          <label class="block text-gray-300 text-sm font-semibold mb-2" for="password_confirmation">
            Confirm Password
          </label>
          <input
            id="password_confirmation"
            v-model="form.password_confirmation"
            type="password"
            required
            minlength="8"
            class="input"
            placeholder="••••••••"
          />
        </div>

        <button
          type="submit"
          :disabled="loading"
          class="btn-primary w-full disabled:opacity-50"
        >
          {{ loading ? 'Creating account...' : 'Register' }}
        </button>
      </form>
    </template>

    <template #footer>
      <p class="text-center text-gray-300 text-sm">
        Already have an account?
        <router-link 
          to="/login" 
          class="text-primary-400 hover:text-primary-300 font-semibold transition-colors"
        >
          Login here
        </router-link>
      </p>
    </template>
  </GuestLayout>
</template>

<script setup>
defineOptions({ name: 'RegisterView' })
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '@/api/modules/auth'
import GuestLayout from '@/layouts/GuestLayout.vue'

const router = useRouter()

const form = ref({
  name: '',
  email: '',
  password: '',
  password_confirmation: ''
})

const loading = ref(false)
const error = ref('')
const success = ref(false)

async function handleRegister() {
  loading.value = true
  error.value = ''
  success.value = false

  if (form.value.password !== form.value.password_confirmation) {
    error.value = 'Passwords do not match'
    loading.value = false
    return
  }

  try {
    await register(form.value)
    success.value = true
    
    setTimeout(() => {
      router.push('/login')
    }, 1500)
  } catch (err) {
    error.value = err.response?.data?.message || 'Registration failed. Please try again.'
    if (err.response?.data?.errors) {
      const errors = Object.values(err.response.data.errors).flat()
      error.value = errors.join(', ')
    }
  } finally {
    loading.value = false
  }
}
</script>
