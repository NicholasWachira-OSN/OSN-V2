<template>
  <div class="min-h-screen app-bg-gradient flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <!-- Optional Logo/Brand at top -->
    <div class="w-full max-w-md">
      <div class="text-center mb-8">
        <img 
          :src="isDark ? '/osn-w.png' : '/osn-d.png'" 
          alt="WoopySport" 
          class="h-16 w-auto mx-auto mb-4 object-contain bg-transparent" 
        />
        <p class="text-gray-600 dark:text-gray-400">Welcome back to the game</p>
      </div>

      <!-- Content Slot (Login/Register form goes here) -->
      <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-2xl border border-gray-300 dark:border-white/10 p-8">
        <slot />
      </div>

      <!-- Footer link for switching between login/register -->
      <div v-if="$slots.footer" class="mt-6 text-center">
        <slot name="footer" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { useDarkMode } from '@/composables/useDarkMode'

// Get dark mode state for logo switching
const { isDark } = useDarkMode()
</script>

<style scoped>
/* No custom background needed - using global html background */
.app-bg-gradient {
  /* Inherits from html element background */
}

</style>
