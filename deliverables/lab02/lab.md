# Lab 2 - Notes

## Récupération des dépendances

``pnpm install``

Après remove des node_modules, le cache pnpm permet de réinstaller sans re-téléchargement
``Progress: resolved 936, reused 936, downloaded 0, added 936, done``

## Vérification du typage statique du code

``pnpm nuxt typecheck``

## Analyse statique du code

``pnpm eslint . --ext .ts,.vue``

## Construction du "package" à déployer

``pnpm nuxt build``

## Exécution des tests

``pnpm vitest run``

## Outdated Dependencies

``pnpm outdated``

## Vulnerabilities

``pnpm audit``
