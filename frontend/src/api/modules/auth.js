import apiClient from '../client'

export async function register(credentials) {
  console.log('🔐 Attempting to Register...')
  await apiClient.get('/sanctum/csrf-cookie')
  const response = await apiClient.post('/api/v2/register', credentials)
  return response.data
}

export async function login(credentials) {
  console.log('🔐 Attempting login...')
  await apiClient.get('/sanctum/csrf-cookie')
  const response = await apiClient.post('/api/v2/login', credentials)
  console.log('🔐 Login response:', response.status, response.data)
  console.log('🍪 Cookies after login:', document.cookie)
  return response.data
}

export async function logout() {
  console.log('🚪 Attempting logout...')
  const response = await apiClient.post('/api/v2/logout')
  console.log('🚪 Logout response:', response.status)
  return response.data
}

export async function getUser() {
  console.log('👤 Fetching user from /api/v2/user...')
  console.log('Cookies being sent:', document.cookie)
  const response = await apiClient.get('/api/v2/user')
  console.log('👤 User fetched:', response.data)
  return response.data
}
