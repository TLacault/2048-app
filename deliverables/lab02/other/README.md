# Lab 2 - Fichiers livrables

## Fichiers principaux

### 1. Script CI amélioré
- **Fichier** : [pipelines/ci.sh](../../pipelines/ci.sh)
- **Description** : Script bash d'intégration continue avec 7 étapes automatisées
- **Documentation** : [pipelines/README.md](../../pipelines/README.md)

### 2. Documentation du lab
- **Notes principales** : [02-notes.md](./02-notes.md)
- **Pour aller plus loin** : [pour-aller-plus-loin.md](./pour-aller-plus-loin.md)
- **Résumé** : [resume-pour-aller-plus-loin.md](./resume-pour-aller-plus-loin.md)

### 3. Test unitaire
- **Fichier** : [app/components/game/Tile.spec.ts](../../app/components/game/Tile.spec.ts)
- **Description** : Tests unitaires pour le composant Tile

### 4. Configurations
- **ESLint** : [eslint.config.mjs](../../eslint.config.mjs)
- **Vitest** : [vitest.config.ts](../../vitest.config.ts)
- **.gitignore** : Mise à jour avec `reports/` et `publish/`

## Étapes du script CI

1. ✅ Installation des dépendances (`pnpm install --frozen-lockfile`)
2. ✅ Vérification du typage statique (`pnpm typecheck`)
3. ✅ Analyse statique du code (`pnpm lint`)
4. ✅ Construction du package (`pnpm generate`)
5. ✅ Exécution des tests (`pnpm test`)
6. ✅ Analyse des dépendances obsolètes (`pnpm outdated --format json`)
7. ✅ Analyse des vulnérabilités (`pnpm audit --json`)

## Rapports générés

Les rapports sont créés automatiquement dans `reports/` :
- `outdated-dependencies.json` : Dépendances à mettre à jour
- `vulnerable-dependencies.json` : Vulnérabilités de sécurité

## Commandes utiles

```bash
# Exécuter le script CI complet
bash pipelines/ci.sh

# Corriger les vulnérabilités
pnpm audit --fix && pnpm install

# Mettre à jour les dépendances
pnpm update

# Vérifier l'audit de sécurité
pnpm audit
```

## Vulnérabilités testées

Lodash 4.17.20 a été ajouté pour tester le système de détection :
- 8 vulnérabilités détectées (6 high, 2 moderate)
- Corrigées automatiquement avec `pnpm audit --fix`
- Version finale : lodash 4.17.23 (sécurisée)

## Notions apprises

1. **pnpm** : Gestionnaire de packages avec cache global
2. **TypeScript** : Type-checking avec vue-tsc
3. **ESLint** : Analyse statique de code
4. **Vitest** : Framework de tests unitaires
5. **Nuxt/Vite** : Build et génération de site statique
6. **Sécurité** : Audit et correction automatique des vulnérabilités
7. **Maintenance** : Suivi des dépendances obsolètes
8. **CI/CD** : Automatisation des tâches de vérification
