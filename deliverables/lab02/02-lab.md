# Lab 2 - Script d'intégration continue

## Objectif

Écrire un script shell qui automatise les étapes d'intégration continue : install, typecheck, lint, build, tests.

## Outils utilisés

| Outil | Rôle |
|---|---|
| `pnpm install` | installation des dépendances (cache local, rapide au 2e run) |
| `vue-tsc` / `nuxt typecheck` | vérification du typage TypeScript |
| `eslint` | analyse statique du code (règles de style, erreurs potentielles) |
| `nuxt build` / Vite | compilation du bundle de production dans `.output/` |
| `vitest` | exécution des tests unitaires (API compatible Jest, natif Vite) |

## Concepts clés

**pnpm et le cache** : pnpm stocke les dépendances dans un store centralisé. Si un paquet est déjà téléchargé, il est simplement lié (hardlink) sans re-téléchargement.

**Typecheck** : `nuxt typecheck` utilise `vue-tsc` en interne. Il remonte les erreurs de type sur les props et le code TypeScript, même ce que l'IDE ne montrerait pas sur des fichiers non ouverts.

**ESLint** : outil d'analyse statique configurable via `eslint.config.mjs`. Remonte erreurs et warnings selon les règles définies. Intégré à l'IDE pour feedback en temps réel.

**Vite** : bundler moderne, beaucoup plus rapide que Webpack grâce au HMR natif et à l'ESM. Utilisé en interne par Nuxt.

**Vitest** : framework de test natif Vite. API compatible avec Jest. Idéal pour tester des composants Vue avec `@vue/test-utils`.

## Structure du script (lab2.sh)

```
pnpm install
pnpm nuxt typecheck
pnpm nuxt build
pnpm eslint .
pnpm vitest run
```

## Cheat sheet

```bash
pnpm install                  # installer les dépendances
pnpm nuxt typecheck           # vérifier les types TS/Vue
pnpm eslint .                 # analyser le code statiquement
pnpm nuxt build               # compiler le bundle de prod (.output/)
pnpm nuxt preview             # lancer le bundle compilé en local
pnpm vitest run               # lancer les tests une fois (non-watch)
pnpm outdated --format json   # lister les dépendances obsolètes
pnpm audit --json             # détecter les vulnérabilités connues
```
