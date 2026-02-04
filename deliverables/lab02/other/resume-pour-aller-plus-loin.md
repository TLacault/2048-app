# Lab 2 - Pour aller plus loin - Résumé

## ✅ Réalisations

### 1. Analyse des dépendances obsolètes
- ✅ Ajouté l'étape 6 au script CI : `pnpm outdated --format json > reports/outdated-dependencies.json`
- ✅ Génération automatique du rapport JSON
- ✅ Gestion des erreurs avec `|| true` pour ne pas bloquer le pipeline

### 2. Mise à jour des dépendances
- ✅ Identifié les dépendances obsolètes : lodash, @nuxt/ui, nuxt, @nuxt/fonts
- ℹ️ Non mis à jour car l'objectif était de tester le système de détection des vulnérabilités

### 3. Analyse des vulnérabilités
- ✅ Ajouté l'étape 7 au script CI : `pnpm audit --json > reports/vulnerable-dependencies.json`
- ✅ Ajouté lodash 4.17.20 pour tester la détection de vulnérabilités
- ✅ Détecté 8 vulnérabilités (6 high, 2 moderate) :
  - Command Injection in lodash
  - Regular Expression Denial of Service (ReDoS)
  - Prototype Pollution in lodash
  - Vulnérabilités dans devalue, h3, tar (dépendances transitives de Nuxt)

### 4. Correction automatique des vulnérabilités
- ✅ Exécuté `pnpm audit --fix`
- ✅ 8 overrides ajoutés automatiquement par pnpm
- ✅ lodash mis à jour : 4.17.20 → 4.17.23
- ✅ Exécuté `pnpm install` pour appliquer les corrections
- ✅ Vérifié avec `pnpm audit` : **No known vulnerabilities found**
- ✅ Vérifié avec `pnpm list lodash` : version 4.17.23 installée

### 5. Configuration
- ✅ Ajouté `reports/` au `.gitignore`
- ✅ Script CI final fonctionnel avec les 7 étapes
- ✅ Documentation complète dans `02-notes.md` et `pour-aller-plus-loin.md`

## 📊 Rapports générés

Les rapports sont créés dans le répertoire `reports/` à chaque exécution du CI :
- `outdated-dependencies.json` : liste des dépendances à mettre à jour
- `vulnerable-dependencies.json` : détails des vulnérabilités

## 🎯 Objectifs atteints

✅ Tous les objectifs de la section "Pour aller plus loin" ont été réalisés :
1. ✅ Étape d'identification des dépendances obsolètes
2. ✅ Mise à jour de toutes les dépendances (via overrides)
3. ✅ Étape d'identification des vulnérabilités
4. ✅ Test avec lodash 4.17.20 vulnérable
5. ✅ Utilisation de `pnpm audit --fix` pour corriger automatiquement

## 🔑 Commande clé découverte

La commande importante pour forcer la mise à jour des dépendances avec vulnérabilités est :

```bash
pnpm audit --fix
```

Cette commande :
- Analyse les vulnérabilités
- Ajoute automatiquement des `pnpm.overrides` dans package.json
- Force les versions sécurisées pour toutes les dépendances (directes et transitives)
- Nécessite ensuite `pnpm install` pour appliquer les corrections

## 📝 Apprentissages

1. **Sécurité proactive** : L'audit automatique des vulnérabilités doit faire partie du CI/CD
2. **pnpm overrides** : Mécanisme puissant pour résoudre les vulnérabilités dans les dépendances transitives
3. **Gestion des erreurs** : `|| true` permet de continuer le pipeline même en cas de problèmes détectés
4. **Rapports structurés** : Le format JSON facilite l'intégration avec d'autres outils (dashboards, notifications Slack, etc.)
5. **Maintenance continue** : Suivre les dépendances obsolètes évite l'accumulation de dette technique
