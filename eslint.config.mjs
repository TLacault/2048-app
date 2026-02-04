// @ts-check
import withNuxt from "./.nuxt/eslint.config.mjs";

export default withNuxt({
  // Ignorer temporairement les fichiers avec problèmes de parsing
  // Ces erreurs sont dues à la syntaxe defineProps TypeScript-only qui n'est pas encore
  // complètement supportée par le parser ESLint
  ignores: [
    "app/components/game/ScoreDisplay.vue",
    "app/components/game/Tile.vue",
  ],
});
