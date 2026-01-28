# Lab 2 - Notes

## Méthodologie

**Script Bash** avec 5 étapes :
1. `pnpm install --frozen-lockfile` - install des dépendances
2. `pnpm typecheck` - vérif typage TypeScript
3. `pnpm lint` - analyse ESLint
4. `pnpm generate` + copie vers `publish/` - build
5. `pnpm test` - tests unitaires

J'ai ajouter des scripts npm (`lint`, `test`, `typecheck`) pour simplifier les commandes.

## Ce que j'ai appris

- **pnpm** : cache global, pas de re-téléchargement, `--frozen-lockfile` pour la CI
- **vue-tsc** : détecte les erreurs de typage dans les composants Vue
- **ESLint** : config via `@nuxt/eslint`, problème avec la syntaxe `defineProps<{}>()` → contourné en ignorant les fichiers concernés
- **Nuxt/Vite** : `nuxt generate` crée un site statique dans `.output/public`
- **Vitest** : API style Jest, `@vue/test-utils` pour tester les composants Vue

Test créé pour `Tile.vue` : vérif valeurs + classes CSS.

## Difficultés

1. ESLint plante sur `defineProps<{}>()` → ajouté `ignores` dans config
2. Pas d'option `--output-dir` direct avec Nuxt → `cp -r` vers `publish/`
3. Warning version Vitest mais ça marche quand même
