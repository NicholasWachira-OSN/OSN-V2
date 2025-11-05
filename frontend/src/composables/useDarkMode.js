import { useDark, useToggle } from '@vueuse/core'

/**
 * Composable for managing dark mode
 * Uses VueUse's useDark with localStorage persistence
 * Works with Tailwind CSS v4 dark mode
 */
export function useDarkMode() {
  // useDark automatically:
  // - Adds/removes 'dark' class on <html> element
  // - Persists preference to localStorage
  const isDark = useDark({
    selector: 'html',
    attribute: 'class',
    valueDark: 'dark',
    valueLight: '',
    storageKey: 'theme-mode',
  })

  // Create a toggle function
  const toggleDark = useToggle(isDark)

  // Debug logging
  console.log('useDarkMode initialized:', {
    isDark: isDark.value,
    htmlElement: document.documentElement,
    currentClass: document.documentElement.className
  })

  return {
    isDark,
    toggleDark,
  }
}
