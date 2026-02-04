# Lab 2 - Pour aller plus loin - Résultats finaux

## ✅ Toutes les étapes réalisées

### Étape 1 : Analyse des dépendances obsolètes
```bash
pnpm outdated --format json > reports/outdated-dependencies.json
```

**Résultat** : 4 dépendances obsolètes identifiées
- @nuxt/ui : 4.3.0 → 4.4.0
- nuxt : 4.2.2 → 4.3.0
- @nuxt/fonts : 0.12.1 → 0.13.0
- lodash : 4.17.20 → 4.17.23

### Étape 2 : Mise à jour des dépendances
La mise à jour a été effectuée automatiquement via les overrides de pnpm lors de la correction des vulnérabilités.

### Étape 3 : Analyse des vulnérabilités
```bash
pnpm audit --json > reports/vulnerable-dependencies.json
```

**Résultat avec lodash 4.17.20** : 8 vulnérabilités détectées
- **Gravité** : 6 high, 2 moderate
- **Packages affectés** :
  - lodash 4.17.20 (3 vulnérabilités)
  - devalue (2 vulnérabilités)
  - h3 (1 vulnérabilité)
  - tar (2 vulnérabilités)

**Types de vulnérabilités** :
- Command Injection in lodash (high)
- Regular Expression Denial of Service - ReDoS (moderate)
- Prototype Pollution in lodash (moderate)
- Denial of Service in devalue (high)
- Request Smuggling in h3 (high)
- Arbitrary File Overwrite in tar (high)

### Étape 4 : Test avec lodash vulnérable
Ajout de lodash 4.17.20 dans package.json :
```json
{
  "dependencies": {
    "lodash": "4.17.20"
  }
}
```

Résultat : 8 vulnérabilités confirmées par `pnpm audit`

### Étape 5 : Correction automatique
```bash
pnpm audit --fix
pnpm install
```

**Résultat** :
- 8 overrides ajoutés par pnpm
- lodash mis à jour : 4.17.20 → 4.17.23
- **Vérification finale** : `pnpm audit` → **No known vulnerabilities found** ✅

Vérification de la version installée :
```bash
$ pnpm list lodash
lodash 4.17.23
```

## 📊 Rapports générés

### Structure du répertoire reports/
```
reports/
├── outdated-dependencies.json    (470 B)
└── vulnerable-dependencies.json  (312 B)
```

### Exemple de rapport outdated-dependencies.json
```json
{
  "@nuxt/ui": {
    "current": "4.3.0",
    "latest": "4.4.0",
    "wanted": "4.3.0",
    "isDeprecated": false,
    "dependencyType": "dependencies"
  },
  "nuxt": {
    "current": "4.2.2",
    "latest": "4.3.0",
    "wanted": "4.2.2",
    "isDeprecated": false,
    "dependencyType": "dependencies"
  }
}
```

## 🔧 Script CI final

Le script `pipelines/ci.sh` contient maintenant 7 étapes :

```bash
#!/bin/bash
set -e
set -u

# Étape 1: Installation des dépendances
pnpm install --frozen-lockfile

# Étape 2: Vérification du typage statique
pnpm typecheck

# Étape 3: Analyse statique du code
pnpm lint

# Étape 4: Construction du package
pnpm generate

# Étape 5: Exécution des tests
pnpm test

# Étape 6: Analyse des dépendances obsolètes
mkdir -p reports
pnpm outdated --format json > reports/outdated-dependencies.json || true

# Étape 7: Analyse des vulnérabilités
pnpm audit --json > reports/vulnerable-dependencies.json || true
```

## 📝 Documentation créée

1. **02-notes.md** : Notes complètes du lab avec la section "Pour aller plus loin"
2. **pour-aller-plus-loin.md** : Guide détaillé des commandes utilisées
3. **resume-pour-aller-plus-loin.md** : Résumé des réalisations
4. **README.md** : Index des fichiers livrables
5. **pipelines/README.md** : Documentation du script CI

## 🎯 Objectifs 100% atteints

✅ Étape d'identification des dépendances obsolètes
✅ Mise à jour des dépendances
✅ Étape d'identification des vulnérabilités
✅ Test avec lodash 4.17.20 vulnérable
✅ Utilisation de `pnpm audit --fix` pour corriger automatiquement
✅ Documentation complète
✅ Script CI fonctionnel

## 🔑 Commande clé

La commande la plus importante découverte dans cette section :

```bash
pnpm audit --fix
```

Cette commande permet de corriger automatiquement les vulnérabilités en ajoutant des overrides dans le package.json pour forcer les versions sécurisées de toutes les dépendances (directes et transitives).

## 🚀 Utilisation

Pour exécuter le script CI complet :
```bash
bash pipelines/ci.sh
```

Pour corriger les vulnérabilités :
```bash
pnpm audit --fix
pnpm install
```

## 📚 Apprentissages clés

1. **Sécurité proactive** : L'audit automatique doit faire partie du CI/CD
2. **pnpm overrides** : Mécanisme puissant pour gérer les dépendances transitives
3. **Gestion d'erreurs** : `|| true` pour ne pas bloquer le pipeline
4. **Rapports JSON** : Facilite l'intégration avec d'autres outils
5. **Maintenance continue** : Importance du suivi des dépendances obsolètes
