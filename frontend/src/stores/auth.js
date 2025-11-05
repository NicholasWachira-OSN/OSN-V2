import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login, logout, getUser, register } from '@/api/modules/auth'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const isAuthenticated = ref(false)
  const loading = ref(false)

  async function registerUser(credentials) {
    const response = await register(credentials)
    return response
  }

  async function loginUser(credentials) {
    try {
      const response = await login(credentials)
      user.value = response.data || response
      isAuthenticated.value = true
      console.log('✅ Login successful:', user.value)
      return response
    } catch (err) {
      console.error('❌ Login failed:', err)
      user.value = null
      isAuthenticated.value = false
      throw err
    }
  }

  async function logoutUser() {
    try {
      await logout()
      user.value = null
      isAuthenticated.value = false
      console.log('✅ Logout successful')
    } catch (err) {
      console.error('❌ Logout failed:', err)
      // Clear state anyway on logout attempt
      user.value = null
      isAuthenticated.value = false
      throw err
    }
  }

  async function fetchUser() {
    // Prevent duplicate calls
    if (loading.value) {
      console.log('⏳ Already fetching user...')
      return
    }

    loading.value = true
    try {
      const response = await getUser()
      user.value = response.data || response
      isAuthenticated.value = true
      console.log('✅ Session restored:', user.value)
    } catch {
      console.log('ℹ️ No active session')
      user.value = null
      isAuthenticated.value = false
      // Don't throw - this is expected when not logged in
    } finally {
      loading.value = false
    }
  }

  return { user, isAuthenticated, loading, registerUser, loginUser, logoutUser, fetchUser }
})
