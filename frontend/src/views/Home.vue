<!-- eslint-disable vue/multi-word-component-names -->
<template>
  <AuthenticatedLayout>
    <!-- Hero Section with Background Image -->
    <div class="hero relative h-[75vh] bg-cover bg-center" :style="{ backgroundImage: `url(${heroImage})` }">
      <div class="absolute inset-0 bg-black bg-opacity-60 flex flex-col justify-center items-center text-center px-4">
        <h1 class="text-5xl font-bold text-white leading-tight mb-4">
          Home of Africa Sports<br>
          Live Games & Highlights<br>
          Your Ultimate Hub
        </h1>
        <p class="text-2xl font-semibold text-gray-300 mb-6">
          Stream pay-per-view games, access exclusive stats, and dive into basketball action.
        </p>
        <button class="px-8 py-3 bg-gradient-to-r from-purple-600 to-purple-800 text-white text-lg uppercase font-bold rounded-lg shadow-lg hover:shadow-xl hover:scale-105 transition duration-300">
          Watch Now
        </button>
      </div>
    </div>

    <!-- Leagues Section -->
    <div class="w-full mb-6 mt-8">
      <h2 class="ml-4 text-2xl font-bold mb-4 text-gray-900 dark:text-white">Leagues</h2>
      <div class="flex gap-4 justify-center overflow-x-auto no-scrollbar px-2" style="scroll-snap-type: x mandatory;">
        <div
          v-for="(tournament, idx) in tournaments"
          :key="idx"
          class="relative flex items-center min-w-[220px] max-w-xs w-64 h-24 bg-white/80 dark:bg-white/10 backdrop-blur-lg rounded-lg shadow-lg overflow-hidden scroll-snap-align-start flex-shrink-0 hover:scale-105 transition-transform duration-300"
        >
          <!-- Background thumbnail with low opacity -->
          <img
            :src="tournament.thumbnail"
            class="absolute inset-0 w-full h-full object-cover opacity-20"
            alt="Tournament thumbnail"
          />
          <!-- Tournament name in bold, above the image -->
          <div class="relative z-10 flex items-center justify-center w-full h-full">
            <span class="text-lg md:text-xl font-bold text-gray-900 dark:text-white drop-shadow-lg text-center px-2">
              {{ tournament.name }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Live and Upcoming Games Section -->
    <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg p-6 mb-6 mx-4 rounded-lg">
      <h2 class="text-2xl font-bold mb-4 text-gray-900 dark:text-white">Live and Upcoming Games</h2>
      <div class="relative w-full">
        <div 
          ref="liveCarousel" 
          class="flex gap-4 overflow-x-auto no-scrollbar scroll-smooth"
          @mouseenter="pauseAutoScroll('live')" 
          @mouseleave="resumeAutoScroll('live')"
        >
          <GameCard 
            v-for="(game, index) in upcomingGames" 
            :key="`live-${index}`" 
            :game="game" 
          />
        </div>
        
        <!-- Navigation Arrows -->
        <button 
          class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-purple-600 text-white p-3 rounded-full hover:bg-purple-700 transition-colors duration-200 shadow-lg"
          @click="scrollLeft('liveCarousel')"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
        </button>
        <button 
          class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-purple-600 text-white p-3 rounded-full hover:bg-purple-700 transition-colors duration-200 shadow-lg"
          @click="scrollRight('liveCarousel')"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- Game Highlights Section -->
    <div class="bg-white/80 dark:bg-white/10 backdrop-blur-lg p-6 mb-6 mx-4 rounded-lg">
      <h2 class="text-2xl font-bold mb-4 text-gray-900 dark:text-white">Game Highlights</h2>
      <div class="relative w-full">
        <div 
          ref="highlightsCarousel" 
          class="flex gap-4 overflow-x-auto no-scrollbar scroll-smooth"
          @mouseenter="pauseAutoScroll('highlights')" 
          @mouseleave="resumeAutoScroll('highlights')"
        >
          <GameCard 
            v-for="(game, index) in highlightGames" 
            :key="`highlight-${index}`" 
            :game="game" 
          />
        </div>
        
        <!-- Navigation Arrows -->
        <button 
          class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-purple-600 text-white p-3 rounded-full hover:bg-purple-700 transition-colors duration-200 shadow-lg"
          @click="scrollLeft('highlightsCarousel')"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
        </button>
        <button 
          class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-purple-600 text-white p-3 rounded-full hover:bg-purple-700 transition-colors duration-200 shadow-lg"
          @click="scrollRight('highlightsCarousel')"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </button>
      </div>
    </div>
  </AuthenticatedLayout>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import AuthenticatedLayout from '@/layouts/AuthenticatedLayout.vue'
import GameCard from '@/components/GameCard.vue'

// Hero image
const heroImage = ref('http://res.cloudinary.com/ddsbdyeyj/image/upload/v1710946019/7d0e6686-265a-496c-a4af-b068b60ca22b.jpg')

// Tournaments data
const tournaments = ref([
  {
    name: 'Lagos Cup',
    thumbnail: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Nairobi Open',
    thumbnail: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Cape Town Classic',
    thumbnail: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Accra Challenge',
    thumbnail: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Jozi Jumpers',
    thumbnail: 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Dakar Dunkers',
    thumbnail: 'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&w=400&q=80'
  },
  {
    name: 'Harare Heroes',
    thumbnail: 'https://images.unsplash.com/photo-1502086223501-7ea6ecd79368?auto=format&fit=crop&w=400&q=80'
  }
])

// Games data
const gamesData = ref([
  {
    scheduled_time: '2025-10-16 18:00',
    team_a: { name: 'Lagos Lions', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    team_b: { name: 'Nairobi Warriors', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    score: '98-92',
    thumbnail: 'https://media.istockphoto.com/id/467634080/photo/basketball-game.jpg?s=612x612&w=0&k=20&c=8BGyRa8U4AXoqstjPXA5t8ukZs6EEUn0PhQsmKOh8Zw=',
    status: 'Final'
  },
  {
    scheduled_time: '2025-10-17 19:30',
    team_a: { name: 'Cape Eagles', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    team_b: { name: 'Accra Stars', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    score: '85-89',
    thumbnail: 'https://media.istockphoto.com/id/1004186904/photo/the-african-man-basketball-player-jumping-with-ball.jpg?s=612x612&w=0&k=20&c=QW_fdTSTDC1DZXbTkhrhWqLsnpcoq_yoV6ECUMBtkiw=',
    status: 'Final'
  },
  {
    scheduled_time: '2025-10-18 17:00',
    team_a: { name: 'Jozi Jumpers', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    team_b: { name: 'Dakar Dunkers', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    score: null,
    thumbnail: 'https://media.gettyimages.com/id/1203194720/video/basketball-player-throwing-the-ball-but-missing-the-shot.jpg?s=640x640&k=20&c=cUnr2-fK5NHIYAgsmqByrhR9PZAQRashNAcSd6LI7UI=',
    status: 'Live'
  },
  {
    scheduled_time: '2025-10-19 20:00',
    team_a: { name: 'Kampala Kings', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    team_b: { name: 'Addis Ababa Aces', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    score: '102-95',
    thumbnail: 'https://media.gettyimages.com/id/1199423645/video/basketball-player-dunking-the-ball-in-the-game.jpg?s=640x640&k=20&c=mtNhf6QSAgSpWJCzA8r_03xF6dSxSjnJjMgdd897jkk=',
    status: 'Final'
  },
  {
    scheduled_time: '2025-10-20 18:30',
    team_a: { name: 'Team Alpha', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    team_b: { name: 'Team Beta', image: 'https://static.vecteezy.com/system/resources/previews/015/324/920/non_2x/basketball-cracked-wall-basketball-club-graphic-design-logos-or-icons-illustration-vector.jpg' },
    score: '85-92',
    thumbnail: 'https://media.istockphoto.com/id/1253350295/photo/basketball-players-tackling-for-ball.jpg?s=612x612&w=0&k=20&c=5G_4B96qYdci3FF1yLgulajpk8zAw7y02tuWBcFs9UM=',
    status: 'Final'
  }
])

// Computed properties
const upcomingGames = computed(() => gamesData.value.slice(0, 7))
const highlightGames = computed(() => gamesData.value.slice(0, 7))

// Carousel refs
const liveCarousel = ref(null)
const highlightsCarousel = ref(null)
const autoScrollIntervals = ref({
  live: null,
  highlights: null
})

// Carousel methods
const scrollLeft = (carouselRef) => {
  const container = carouselRef === 'liveCarousel' ? liveCarousel.value : highlightsCarousel.value
  if (container) {
    container.scrollBy({ left: -340, behavior: 'smooth' })
  }
}

const scrollRight = (carouselRef) => {
  const container = carouselRef === 'liveCarousel' ? liveCarousel.value : highlightsCarousel.value
  if (container) {
    container.scrollBy({ left: 340, behavior: 'smooth' })
  }
}

const startAutoScroll = (type) => {
  const container = type === 'live' ? liveCarousel.value : highlightsCarousel.value
  
  autoScrollIntervals.value[type] = setInterval(() => {
    if (container) {
      const maxScroll = container.scrollWidth - container.clientWidth
      if (container.scrollLeft >= maxScroll) {
        container.scrollTo({ left: 0, behavior: 'smooth' })
      } else {
        container.scrollBy({ left: 340, behavior: 'smooth' })
      }
    }
  }, 5000)
}

const pauseAutoScroll = (type) => {
  if (autoScrollIntervals.value[type]) {
    clearInterval(autoScrollIntervals.value[type])
  }
}

const resumeAutoScroll = (type) => {
  startAutoScroll(type)
}

// Lifecycle hooks
onMounted(() => {
  startAutoScroll('live')
  startAutoScroll('highlights')
})

onBeforeUnmount(() => {
  Object.values(autoScrollIntervals.value).forEach(interval => {
    if (interval) clearInterval(interval)
  })
})
</script>

<style scoped>
.no-scrollbar::-webkit-scrollbar {
  display: none;
}

.no-scrollbar {
  -ms-overflow-style: none;
  scrollbar-width: none;
}

.scroll-snap-align-start {
  scroll-snap-align: start;
}
</style>
