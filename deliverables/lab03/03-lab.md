# Lab 3 - Pipeline CI avec GitHub Actions

## Objectif

Transposer le script du lab 2 en pipeline GitHub Actions : automatiser les étapes CI et produire un artifact de build.

## GitHub Actions — concepts fondamentaux

- **Workflow** : fichier YAML dans `.github/workflows/`. Déclenché par des événements GitHub.
- **Job** : groupe de steps exécutés sur un runner. Les jobs sont indépendants et parallèles par défaut.
- **Step** : commande shell (`run:`) ou action réutilisable (`uses:`).
- **Action** : bloc réutilisable publié sur le Marketplace (ex: `actions/checkout`, `pnpm/action-setup`).
- **Runner** : VM fournie par GitHub (ex: `ubuntu-latest`) sur laquelle le job s'exécute.
- **Artifact** : fichier ou dossier produit par un job, uploadé via `actions/upload-artifact` pour être téléchargé ou réutilisé.

## Pipeline CI mis en place

1. Checkout du code (`actions/checkout`)
2. Setup pnpm (`pnpm/action-setup`) + Node.js avec cache pnpm intégré
3. `pnpm install`
4. Typecheck, lint, build, tests
5. Upload de l'artifact `.output/` (`actions/upload-artifact`)

## Outils complémentaires

**Extension GitHub Actions (VS Code)** : autocomplétion, validation des workflows YAML et visualisation des runs depuis l'éditeur.

**act** : simule des pipelines GitHub Actions en local via Docker, sans avoir à pusher.

```bash
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
./bin/act --list   # lister les jobs disponibles
./bin/act push     # simuler un événement push en local
```

## Cheat sheet

```yaml
# Triggers courants
on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

# Setup pnpm + Node.js avec cache
- uses: pnpm/action-setup@v4
- uses: actions/setup-node@v4
  with:
    node-version: 22
    cache: pnpm

# Installer les dépendances
- run: pnpm install

# Upload artifact
- uses: actions/upload-artifact@v4
  with:
    name: build
    path: .output/
```
