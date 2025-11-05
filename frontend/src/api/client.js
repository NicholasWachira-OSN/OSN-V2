import axios from 'axios'

const apiClient = axios.create({
  baseURL: '', // Use proxy - relative URLs
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
})

// Read XSRF-TOKEN cookie and set X-XSRF-TOKEN header explicitly
apiClient.interceptors.request.use((config) => {
  const match = document.cookie.match(new RegExp('(^|; )XSRF-TOKEN=([^;]*)'))
  if (match) {
    try {
      const token = decodeURIComponent(match[2])
      config.headers['X-XSRF-TOKEN'] = token
    } catch (e) {
      // ignore decode error in tests/edge cases
      console.debug('cookie decode failed', e)
    }
  }
  return config
})

export default apiClient