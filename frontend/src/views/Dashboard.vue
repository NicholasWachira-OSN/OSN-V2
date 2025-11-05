<template>
  <AuthenticatedLayout>
    <!-- Main Content -->
    <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <div class="px-4 py-6 sm:px-0">
        <!-- Welcome Card -->
        <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-xl border border-gray-300 dark:border-white/10 p-6 mb-6">
          <h2 class="text-2xl font-bold mb-4 text-gray-900 dark:text-white">Welcome to Dashboard</h2>
          <p class="text-gray-600 dark:text-gray-300 mb-2">You are successfully logged in!</p>
          <p class="text-gray-600 dark:text-gray-300">
            Email: <strong class="text-gray-900 dark:text-white">{{ user?.email }}</strong>
          </p>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-xl border border-gray-300 dark:border-white/10 p-6">
            <div class="flex items-center">
              <div class="p-3 rounded-full bg-blue-500 bg-opacity-75">
                <svg
                  class="h-8 w-8 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <h3 class="text-gray-600 dark:text-gray-400 text-sm">Total Users</h3>
                <p class="text-2xl font-bold text-gray-900 dark:text-white">1,234</p>
              </div>
            </div>
          </div>

          <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-xl border border-gray-300 dark:border-white/10 p-6">
            <div class="flex items-center">
              <div class="p-3 rounded-full bg-green-500 bg-opacity-75">
                <svg
                  class="h-8 w-8 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <h3 class="text-gray-600 dark:text-gray-400 text-sm">Active Sessions</h3>
                <p class="text-2xl font-bold text-gray-900 dark:text-white">567</p>
              </div>
            </div>
          </div>

          <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-xl border border-gray-300 dark:border-white/10 p-6">
            <div class="flex items-center">
              <div class="p-3 rounded-full bg-yellow-500 bg-opacity-75">
                <svg
                  class="h-8 w-8 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6"
                  />
                </svg>
              </div>
              <div class="ml-4">
                <h3 class="text-gray-600 dark:text-gray-400 text-sm">Performance</h3>
                <p class="text-2xl font-bold text-gray-900 dark:text-white">98.5%</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Activity -->
        <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-xl border border-gray-300 dark:border-white/10 p-6">
          <h3 class="text-lg font-bold mb-4 text-gray-900 dark:text-white">Recent Activity</h3>
          <div class="space-y-3">
            <div class="flex items-center justify-between py-3 border-b border-gray-300 dark:border-white/10">
              <div>
                <p class="font-medium text-gray-900 dark:text-white">New user registered</p>
                <p class="text-sm text-gray-600 dark:text-gray-400">2 minutes ago</p>
              </div>
              <span
                class="px-3 py-1 bg-green-500/20 text-green-700 dark:text-green-300 rounded-full text-sm border border-green-500/30"
                >Success</span
              >
            </div>
            <div class="flex items-center justify-between py-3 border-b border-gray-300 dark:border-white/10">
              <div>
                <p class="font-medium text-gray-900 dark:text-white">API call completed</p>
                <p class="text-sm text-gray-600 dark:text-gray-400">5 minutes ago</p>
              </div>
              <span
                class="px-3 py-1 bg-blue-500/20 text-blue-700 dark:text-blue-300 rounded-full text-sm border border-blue-500/30"
                >Info</span
              >
            </div>
            <div class="flex items-center justify-between py-3">
              <div>
                <p class="font-medium text-gray-900 dark:text-white">Database backup completed</p>
                <p class="text-sm text-gray-600 dark:text-gray-400">1 hour ago</p>
              </div>
              <span
                class="px-3 py-1 bg-green-500/20 text-green-700 dark:text-green-300 rounded-full text-sm border border-green-500/30"
                >Success</span
              >
            </div>
          </div>
        </div>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<script setup>
defineOptions({ name: 'DashboardView' })
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import AuthenticatedLayout from '@/layouts/AuthenticatedLayout.vue'
const authStore = useAuthStore()

const user = computed(() => authStore.user)

// Logout is handled in the layout; no local handler needed.
</script>
