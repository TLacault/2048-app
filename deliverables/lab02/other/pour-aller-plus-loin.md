# Pour aller plus loin - Lab 2

## Commandes exécutées

### 1. Analyse des dépendances obsolètes

```bash
# Créer le répertoire pour les rapports
mkdir -p reports

# Générer le rapport des dépendances obsolètes
pnpm outdated --format json > reports/outdated-dependencies.json
```

**Résultat** : Le rapport JSON liste toutes les dépendances ayant des versions plus récentes disponibles.

### 2. Mise à jour des dépendances

```bash
# Pour mettre à jour toutes les dépendances (pas exécuté dans ce TP)
pnpm update

# Ou pour mettre à jour une dépendance spécifique
pnpm update <nom-package>
```

### 3. Ajout d'une dépendance vulnérable pour les tests

Ajout de lodash 4.17.20 dans `package.json` :

```json
{
  "dependencies": {
    "lodash": "4.17.20"
  }
}
```

Puis installation :

```bash
pnpm install
```

### 4. Analyse des vulnérabilités

```bash
# Générer le rapport des vulnérabilités au format JSON
pnpm audit --json > reports/vulnerable-dependencies.json

# Afficher les vulnérabilités dans le terminal
pnpm audit
```

**Résultats avec lodash 4.17.20** :
- 8 vulnérabilités détectées
- Gravité : 2 moderate, 6 high
- Types : Command Injection, ReDoS, Prototype Pollution

### 5. Correction automatique des vulnérabilités

```bash
# Corriger automatiquement les vulnérabilités
pnpm audit --fix

# Appliquer les corrections
pnpm install
```

**Résultat** : 8 overrides ajoutés dans `package.json`, lodash mis à jour vers 4.17.23.

### 6. Vérification finale

```bash
# Vérifier qu'il n'y a plus de vulnérabilités
pnpm audit
```

**Résultat** : `No known vulnerabilities found` ✅

## Configuration Git

Ajout du répertoire `reports/` au `.gitignore` :

```gitignore
# Reports
reports/
```

Cela évite de versionner les rapports générés automatiquement par le CI.

## Intégration dans le script CI

Les deux nouvelles étapes ont été ajoutées à `pipelines/ci.sh` :

```bash
# ===================================
# Étape 6: Analyse des dépendances obsolètes
# ===================================
echo "Analyse des dépendances obsolètes..."
echo "------------------------------------------"
mkdir -p reports
pnpm outdated --format json > reports/outdated-dependencies.json || true
if [ -s reports/outdated-dependencies.json ]; then
    echo "⚠️  Des dépendances obsolètes ont été trouvées"
else
    echo "✅ Toutes les dépendances sont à jour"
fi
echo ""

# ===================================
# Étape 7: Analyse des vulnérabilités
# ===================================
echo "Analyse des vulnérabilités des dépendances..."
echo "------------------------------------------"
pnpm audit --json > reports/vulnerable-dependencies.json || true
if [ -s reports/vulnerable-dependencies.json ]; then
    echo "⚠️  Des vulnérabilités ont été trouvées"
else
    echo "✅ Aucune vulnérabilité trouvée"
fi
echo ""
```

## Connaissances acquises

1. **Gestion de la sécurité** : Importance d'auditer régulièrement les dépendances
2. **Automatisation** : Les rapports JSON permettent l'intégration dans des pipelines CI/CD
3. **pnpm overrides** : Mécanisme puissant pour forcer des versions spécifiques
4. **Gestion d'erreurs** : Utilisation de `|| true` pour ne pas bloquer le pipeline
5. **Maintenance proactive** : Suivre les dépendances obsolètes pour éviter la dette technique
