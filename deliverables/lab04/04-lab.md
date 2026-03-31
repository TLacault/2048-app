# Lab 4 - GitHub Actions avancé

## Objectif

Approfondir les pipelines GitHub Actions : triggers fins, parallelisation, cache, variables, artifacts, déploiement multi-environnements.

## Triggers et conditions

```yaml
on:
  push:
    branches: [main]
    paths-ignore: ['docs/**']   # ne pas déclencher si seuls docs/ sont modifiés
  pull_request:
    branches: [main]
    paths-ignore: ['docs/**']
  workflow_dispatch:
    inputs:
      run_checks:
        type: boolean
        default: true
      environment:
        type: choice
        options: [QA, PROD]
```

`paths-ignore` : filtre les fichiers modifiés. Le pipeline ne se lance pas si seuls ces chemins sont touchés.

## Organisation des jobs

Les jobs sont indépendants par default. `needs:` permet de définir des dépendances entre eux.

```yaml
jobs:
  build: ...
  lint:
    needs: build          # s'exécute après build
    if: github.event_name == 'pull_request'
  test:
    needs: build
    if: github.event_name == 'pull_request'
```

**Comportement selon le trigger :**
- `push` sur `main` : build + upload artifact
- `pull_request` : build + lint / typecheck / test en parallèle
- `workflow_dispatch` : build + deploy (+ checks optionnels selon l'input)

## Variables d'environnement

```yaml
env:
  NODE_VERSION: 22        # variable globale accessible dans tous les jobs

steps:
  - uses: actions/setup-node@v4
    with:
      node-version: ${{ env.NODE_VERSION }}
```

## Cache pnpm

```yaml
- uses: pnpm/action-setup@v4
- uses: actions/setup-node@v4
  with:
    node-version: ${{ env.NODE_VERSION }}
    cache: pnpm             # cache intégré via setup-node
```

Le cache est basé sur le `pnpm-lock.yaml`. Si le lockfile n'a pas changé, les dépendances sont restaurées depuis le cache sans téléchargement.

## Rétention des artifacts

```yaml
- uses: actions/upload-artifact@v4
  with:
    name: build
    path: .output/
    retention-days: ${{ github.ref_name == 'main' && 7 || 1 }}
```

Expression conditionnelle : 7 jours pour `main`, 1 jour sinon.

## Conditions `if`

```yaml
if: github.event_name == 'pull_request'
if: github.event_name == 'workflow_dispatch' && inputs.run_checks
if: github.event_name == 'push'
```
