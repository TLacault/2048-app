# Lab 1 - Environnement & GitHub Copilot

## Objectif

Mise en place de l'environnement de développement et implémentation de l'application 2048 avec GitHub Copilot.

## Stack technique

- **Nuxt** : framework Vue.js full-stack (SSR/SPA)
- **TypeScript** : typage statique sur le code JS
- **Tailwind CSS** : utilitaires CSS inline via classes
- **pnpm** : gestionnaire de paquets rapide, avec cache centralisé

## GitHub Copilot

Copilot est intégré à VS Code via une extension. Il exploite les LLMs pour générer du code en contexte. Quelques usages clés :
- génération de composants à partir d'une description
- complétion de fonctions et de types
- agent "Plan" pour concevoir l'architecture avant d'implémenter
- MCP Servers : plugins qui enrichissent Copilot avec des sources d'info externe (ex: Nuxt UI MCP, Chrome DevTools MCP)

## Méthodologie adoptée

- Phase de conception via l'agent "Plan" avant d'implémenter
- Utilisation des MCP Servers pour avoir une doc à jour (Nuxt UI)
- Debug via le MCP Chrome DevTools pour inspecter le DOM et analyser les erreurs runtime

## Difficultés rencontrées

- Configuration Tailwind CSS : les styles n'étaient pas appliqués — résolu via le MCP Nuxt UI
- Bug d'affichage du score — identifié et corrigé via Chrome DevTools MCP
