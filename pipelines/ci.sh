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
pnpm install --frozen-lockfile
echo "✅ Dépendances installées avec succès"
echo ""

# ===================================
# Étape 2: Vérification du typage statique
# ===================================
echo "Vérification du typage statique..."
echo "------------------------------------------"
pnpm typecheck
echo "✅ Typage statique validé"
echo ""

# ===================================
# Étape 3: Analyse statique du code
# ===================================
echo "Analyse statique du code (ESLint)..."
echo "------------------------------------------"
pnpm lint
echo "✅ Analyse statique terminée sans erreur"
echo ""

# ===================================
# Étape 4: Construction du package
# ===================================
echo "Construction du package..."
echo "------------------------------------------"
# Nuxt génère le build dans .output par défaut
# On utilise nuxt generate pour créer une version statique
pnpm generate
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

echo "=========================================="
echo "✅ Pipeline terminé avec succès!"
echo "=========================================="
