#!/bin/bash

# ===================================
# Script d'intégration continue
# ===================================
# Ce script automatise les tâches CI suivantes:
# 1. Installation des dépendances
# 2. Vérification du typage statique
# 3. Analyse statique du code
# 4. Construction du package
# 5. Exécution des tests
# ===================================

set -e  # Arrêter le script en cas d'erreur
set -u  # Traiter les variables non définies comme des erreurs

echo "=========================================="
echo "Début du pipeline d'intégration continue"
echo "=========================================="
echo ""

# ===================================
# Étape 1: Installation des dépendances
# ===================================
echo "Installation des dépendances..."
echo "------------------------------------------"
pnpm install
echo "✅ Dépendances installées avec succès"
echo ""

# ===================================
# Étape 2: Vérification du typage statique
# ===================================
echo "Vérification du typage statique..."
echo "------------------------------------------"
pnpm nuxt typecheck
echo "✅ Typage statique validé"
echo ""

# ===================================
# Étape 3: Analyse statique du code
# ===================================
echo "Analyse statique du code (ESLint)..."
echo "------------------------------------------"
pnpm lint
echo "✅ Analyse statique terminée sans erreur"
echo ""c

# ===================================
# Étape 4: Construction du package
# ===================================
echo "Construction du package..."
echo "------------------------------------------"
# Nuxt génère le build dans .output par défaut
# On utilise nuxt generate pour créer une version statique
pnpm nuxt generate
# Copier le résultat vers le répertoire publish
rm -rf publish
cp -r .output/public publish
echo "✅ Package construit avec succès dans le répertoire 'publish'"
echo ""

# ===================================
# Étape 5: Exécution des tests
# ===================================
echo "Exécution des tests..."
echo "------------------------------------------"
pnpm test
echo "✅ Tous les tests sont passés"
echo ""

# ===================================
# Étape 6: Analyse des dépendances obsolètes
# ===================================
echo "Analyse des dépendances obsolètes..."
echo "------------------------------------------"
mkdir -p reports
pnpm outdated --format json > reports/outdated-dependencies.json || true
# La commande peut retourner un code d'erreur si des dépendances sont obsolètes
# On utilise '|| true' pour ne pas arrêter le script
if [ -s reports/outdated-dependencies.json ]; then
    echo "⚠️  Des dépendances obsolètes ont été trouvées (voir reports/outdated-dependencies.json)"
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
# La commande peut retourner un code d'erreur si des vulnérabilités sont trouvées
# On utilise '|| true' pour ne pas arrêter le script
if [ -s reports/vulnerable-dependencies.json ]; then
    # Vérifier s'il y a des vulnérabilités
    VULN_COUNT=$(grep -o '"vulnerabilities"' reports/vulnerable-dependencies.json | wc -l || echo "0")
    if [ "$VULN_COUNT" -gt 0 ]; then
        echo "⚠️  Des vulnérabilités ont été trouvées (voir reports/vulnerable-dependencies.json)"
    else
        echo "✅ Aucune vulnérabilité trouvée"
    fi
else
    echo "✅ Aucune vulnérabilité trouvée"
fi
echo ""

echo "=========================================="
echo "✅ Pipeline terminé avec succès!"
echo "=========================================="
