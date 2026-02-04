# Lab 2 - Notes

## Méthodologie

**Script Bash** avec 7 étapes (incluant les étapes "Pour aller plus loin") :
1. `pnpm install --frozen-lockfile` - install des dépendances
2. `pnpm typecheck` - vérif typage TypeScript
3. `pnpm lint` - analyse ESLint
4. `pnpm generate` + copie vers `publish/` - build
5. `pnpm test` - tests unitaires
6. `pnpm outdated --format json` - analyse des dépendances obsolètes
7. `pnpm audit --json` - analyse des vulnérabilités

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

## Pour aller plus loin - Notions apprises

### 1. Analyse des dépendances obsolètes (`pnpm outdated`)

La commande `pnpm outdated --format json` génère un rapport JSON listant toutes les dépendances du projet qui ont des versions plus récentes disponibles. Le rapport indique pour chaque dépendance :
- La version actuelle installée (`current`)
- La dernière version disponible (`latest`)
- La version souhaitée selon les contraintes du `package.json` (`wanted`)
- Le type de dépendance (production ou développement)

**Apprentissages** :
- Cette étape est cruciale pour maintenir un projet à jour et bénéficier des dernières fonctionnalités et corrections de bugs
- Le format JSON permet d'analyser automatiquement les résultats dans des pipelines CI/CD
- J'ai utilisé `|| true` pour que le script ne s'arrête pas si des dépendances obsolètes sont trouvées

**Résultats observés** : Plusieurs dépendances avaient des mises à jour disponibles (lodash 4.17.20 → 4.17.23, @nuxt/ui 4.3.0 → 4.4.0, etc.)

### 2. Analyse des vulnérabilités (`pnpm audit`)

La commande `pnpm audit --json` analyse toutes les dépendances du projet pour identifier les vulnérabilités de sécurité connues. Elle consulte une base de données de vulnérabilités (NPM Security Advisories) et génère un rapport détaillé.

**Apprentissages** :
- Chaque vulnérabilité est classée par niveau de gravité : `moderate`, `high`, `critical`
- Le rapport indique les chemins des dépendances affectées (directes ou transitives)
- Des liens vers les advisories GitHub sont fournis pour plus de détails

**Résultats avec lodash 4.17.20** :
- Command Injection (high)
- Regular Expression Denial of Service - ReDoS (moderate)
- Prototype Pollution (moderate)
- Total : 8 vulnérabilités détectées (6 high, 2 moderate)

### 3. Correction automatique des vulnérabilités (`pnpm audit --fix`)

La commande `pnpm audit --fix` tente de corriger automatiquement les vulnérabilités en :
- Ajoutant des `overrides` dans le `package.json` pour forcer les versions corrigées
- Mettant à jour les dépendances vers des versions sûres sans casser la compatibilité

**Apprentissages** :
- pnpm utilise le champ `pnpm.overrides` dans package.json pour forcer des versions spécifiques de dépendances transitives
- Cette approche est plus sûre qu'une mise à jour manuelle car elle respecte les contraintes de versions
- Après l'exécution, il faut lancer `pnpm install` pour appliquer les corrections

**Résultats** :
- 8 overrides ajoutés automatiquement
- lodash mis à jour de 4.17.20 → 4.17.23
- Toutes les vulnérabilités corrigées (`No known vulnerabilities found`)

### 4. Organisation des rapports

Création d'un répertoire `reports/` pour centraliser tous les rapports d'analyse :
- `outdated-dependencies.json` : liste des dépendances à mettre à jour
- `vulnerable-dependencies.json` : détails des vulnérabilités trouvées

**Apprentissages** :
- Séparer les rapports facilite l'analyse et l'archivage dans les pipelines CI/CD
- Le répertoire est ajouté au `.gitignore` car les rapports sont générés automatiquement et peuvent contenir des données sensibles
- Les rapports JSON peuvent être parsés par d'autres outils (dashboards, notifications, etc.)

### 5. Gestion des erreurs dans le script

J'ai utilisé `|| true` après les commandes d'audit pour éviter que le script ne s'arrête en cas de vulnérabilités ou dépendances obsolètes détectées. Cela permet :
- De continuer le pipeline même si des problèmes sont détectés
- D'avoir une vue complète de tous les checks avant de décider des actions
- De logger les avertissements sans bloquer le déploiement

**Conclusion** : Cette section "Pour aller plus loin" m'a permis de comprendre l'importance de la sécurité et de la maintenance des dépendances dans un projet moderne. Les outils d'audit automatisés sont essentiels pour détecter proactivement les problèmes de sécurité et maintenir un projet sain.
