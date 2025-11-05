<template>
  <footer class="bg-gray-900 dark:bg-black text-gray-300 pt-10 pb-6 border-t border-gray-800">
    <div class="max-w-6xl mx-auto px-6 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
      <!-- Logo + About -->
      <div>
        <div class="flex mb-3">
          <img :src="logoSrc" alt="Okapi Sports Logo" class="h-20 w-auto object-contain" />
        </div>

        <p class="text-sm leading-relaxed text-gray-400 mb-4">
          Your home for live sports, fixtures, highlights, and exclusive updates.
          Join our journey as we redefine sports entertainment in Africa and beyond.
        </p>

        <!-- Newsletter -->
        <div class="mt-3">
          <label for="newsletter" class="block text-sm mb-2 font-semibold text-white">Stay Updated</label>
          <div class="flex items-center space-x-2">
            <input
              id="newsletter"
              v-model="email"
              type="email"
              placeholder="Enter your email"
              class="w-full p-2 rounded-md bg-gray-800 border border-gray-600 text-sm placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-purple-600"
            />
            <button
              @click="subscribe"
              class="px-3 py-2 bg-purple-600 text-white rounded-md text-sm font-semibold hover:bg-purple-700 transition"
            >
              Subscribe
            </button>
          </div>
          <p v-if="message" class="mt-2 text-xs" :class="messageType === 'success' ? 'text-green-400' : 'text-red-400'">
            {{ message }}
          </p>
        </div>
      </div>

      <!-- Quick Links -->
      <div>
        <h3 class="text-lg font-semibold text-white mb-4">Access</h3>
        <ul class="space-y-2">
          <li><router-link to="/home" class="hover:text-purple-400">Home</router-link></li>
          <li><router-link to="/fixtures" class="hover:text-purple-400">Fixtures</router-link></li>
          <li><router-link to="/news" class="hover:text-purple-400">News</router-link></li>
          <li><router-link to="/videos" class="hover:text-purple-400">Videos</router-link></li>
          <li><router-link to="/tournaments" class="hover:text-purple-400">Tournaments</router-link></li>
        </ul>
      </div>

      <!-- Sports -->
      <div>
        <h3 class="text-lg font-semibold text-white mb-4">Sports</h3>
        <ul class="space-y-2">
          <li><router-link to="/category/basketball" class="hover:text-purple-400">Basketball</router-link></li>
          <li><router-link to="/category/rugby" class="hover:text-purple-400">Rugby</router-link></li>
          <li><router-link to="/category/football" class="hover:text-purple-400">Football</router-link></li>
          <li><router-link to="/category/volleyball" class="hover:text-purple-400">Volleyball</router-link></li>
        </ul>
      </div>

      <!-- Connect -->
      <div>
        <h3 class="text-lg font-semibold text-white mb-4">Connect With Us</h3>
        <p class="text-sm text-gray-400 mb-4">Follow us and never miss a moment!</p>

        <div class="flex space-x-4">
          <!-- Instagram -->
          <a href="https://www.instagram.com/okapisportsnetwork" target="_blank" rel="noopener" class="hover:text-pink-500 hover:scale-110 transition transform">
            <i class="fab fa-instagram text-2xl"></i>
          </a>
          <!-- YouTube -->
          <a href="https://www.youtube.com/@OkapiSports" target="_blank" rel="noopener" class="hover:text-red-600 hover:scale-110 transition transform">
            <i class="fab fa-youtube text-2xl"></i>
          </a>
          <!-- Facebook -->
          <a href="https://www.facebook.com/okapisportsnetwork" target="_blank" rel="noopener" class="hover:text-blue-500 hover:scale-110 transition transform">
            <i class="fab fa-facebook text-2xl"></i>
          </a>
          <!-- X (Twitter) -->
          <a href="https://twitter.com/okapisports" target="_blank" rel="noopener" class="hover:text-sky-400 hover:scale-110 transition transform">
            <i class="fab fa-x-twitter text-2xl"></i>
          </a>
        </div>

        <div class="mt-5">
          <a href="/terms" class="text-xs text-gray-400 hover:text-purple-400">Terms &amp; Conditions</a>
        </div>
      </div>
    </div>

    <!-- Bottom Footer -->
    <div class="mt-10 border-t border-gray-800 pt-4 text-center text-gray-500 text-sm">
      <p>© {{ year }} Okapi Sports Network. All rights reserved.</p>
      <p class="mt-1">For inquiries: <a href="mailto:info@okapisports.net" class="hover:text-purple-400">info@okapisports.net</a></p>
    </div>
  </footer>
</template>

<script setup>
defineOptions({ name: 'OsnFooter' })
import { computed, ref } from 'vue'
import { useDarkMode } from '@/composables/useDarkMode'

const { isDark } = useDarkMode()
const logoSrc = computed(() => (isDark.value ? '/osn-w.png' : '/osn-d.png'))
const year = new Date().getFullYear()

const email = ref('')
const message = ref('')
const messageType = ref('success') // 'success' | 'error'

function subscribe() {
  const value = email.value.trim()
  const emailRegex = /[^@\s]+@[^@\s]+\.[^@\s]+/
  if (!emailRegex.test(value)) {
    messageType.value = 'error'
    message.value = 'Please enter a valid email address.'
    return
  }
  // Placeholder: integrate with backend later
  console.log('Subscribe:', value)
  messageType.value = 'success'
  message.value = 'Thanks! You\'re subscribed.'
  email.value = ''
}
</script>

<style>
/* Font Awesome for social icons */
@import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css');
</style>
