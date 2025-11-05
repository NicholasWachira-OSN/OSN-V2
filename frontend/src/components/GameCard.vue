<template>
  <div class="fixture-card flex-none w-[320px] bg-white/90 dark:bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:scale-105 hover:shadow-2xl transition-all duration-300">
    <img :src="game.thumbnail" class="w-full h-48 object-cover" :alt="`${game.team_a.name} vs ${game.team_b.name}`">
    
    <!-- Game Info -->
    <div class="p-4">
      <!-- Status and Date -->
      <div class="mb-3 flex items-center gap-2">
        <span 
          class="inline-block px-3 py-1 text-sm font-semibold rounded"
          :class="game.status === 'Live' ? 'bg-red-500 text-white animate-pulse' : game.status === 'Final' ? 'bg-gray-600 dark:bg-gray-700 text-white' : 'bg-blue-500 text-white'"
        >
          {{ game.status || 'Upcoming' }}
        </span>
        <span class="text-sm text-gray-600 dark:text-gray-300 font-semibold">
          {{ formatDate(game.scheduled_time) }}
        </span>
      </div>

      <!-- Teams and Scores -->
      <div class="space-y-2">
        <!-- Team A -->
        <div class="flex items-center justify-between p-2 rounded hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
          <div class="flex items-center gap-3">
            <img 
              :src="game.team_a.image" 
              class="w-8 h-8 rounded-full object-cover" 
              :alt="game.team_a.name"
            >
            <span class="text-base font-bold text-gray-900 dark:text-white">
              {{ game.team_a.name }}
            </span>
          </div>
          <span v-if="game.score" class="text-lg font-extrabold text-gray-900 dark:text-white">
            {{ game.score.split('-')[0] }}
          </span>
        </div>

        <!-- Team B -->
        <div class="flex items-center justify-between p-2 rounded hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors">
          <div class="flex items-center gap-3">
            <img 
              :src="game.team_b.image" 
              class="w-8 h-8 rounded-full object-cover" 
              :alt="game.team_b.name"
            >
            <span class="text-base font-bold text-gray-900 dark:text-white">
              {{ game.team_b.name }}
            </span>
          </div>
          <span v-if="game.score" class="text-lg font-extrabold text-gray-900 dark:text-white">
            {{ game.score.split('-')[1] }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue'

defineProps({
  game: {
    type: Object,
    required: true
  }
})

const formatDate = (dateString) => {
  const date = new Date(dateString.replace(' ', 'T'))
  const day = date.getDate()
  const weekday = date.toLocaleString('en-US', { weekday: 'short' })
  const month = date.toLocaleString('en-US', { month: 'short' })
  return `${day}, ${weekday}, ${month}`
}
</script>

<style scoped>
.fixture-card {
  scroll-snap-align: start;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.7;
  }
}

.animate-pulse {
  animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
