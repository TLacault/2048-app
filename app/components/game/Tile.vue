<script setup lang="ts">
const props = defineProps<{
  value: number;
}>();

const tileConfig: Record<number, { bg: string; text: string; size: string }> = {
  0: {
    bg: "bg-gray-300 dark:bg-gray-700",
    text: "text-transparent",
    size: "text-4xl",
  },
  2: { bg: "bg-amber-100", text: "text-gray-700", size: "text-4xl" },
  4: { bg: "bg-amber-200", text: "text-gray-700", size: "text-4xl" },
  8: { bg: "bg-orange-300", text: "text-white", size: "text-4xl" },
  16: { bg: "bg-orange-400", text: "text-white", size: "text-4xl" },
  32: { bg: "bg-orange-500", text: "text-white", size: "text-4xl" },
  64: { bg: "bg-orange-600", text: "text-white", size: "text-4xl" },
  128: { bg: "bg-yellow-400", text: "text-white", size: "text-3xl" },
  256: { bg: "bg-yellow-500", text: "text-white", size: "text-3xl" },
  512: { bg: "bg-yellow-600", text: "text-white", size: "text-3xl" },
  1024: { bg: "bg-yellow-700", text: "text-white", size: "text-2xl" },
  2048: { bg: "bg-yellow-500", text: "text-white", size: "text-2xl" },
};

const config = computed(() => {
  return (
    tileConfig[props.value] || {
      bg: "bg-gray-800",
      text: "text-white",
      size: "text-xl",
    }
  );
});
</script>

<template>
  <div
    class="tile w-16 h-16 sm:w-20 sm:h-20 flex items-center justify-center rounded-lg font-bold transition-all duration-100"
    :class="[config.bg, config.text, config.size]"
  >
    {{ value || "" }}
  </div>
</template>

<style scoped>
.tile {
  animation: pop 0.15s ease-out;
}

@keyframes pop {
  0% {
    transform: scale(0.8);
  }
  50% {
    transform: scale(1.05);
  }
  100% {
    transform: scale(1);
  }
}
</style>
