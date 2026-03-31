# Lab 5 - Livraison continue avec Vercel

## Objectif

Mettre en place un pipeline de déploiement continu : déploiement de production avec validation humaine, et déploiement de preview automatique sur chaque PR/MR.

## Vercel

Plateforme d'hébergement serverless orientée frontend (Next.js, Nuxt, etc.).

- **Production** : URL stable, mise à jour manuellement ou via promotion
- **Preview** : URL unique par déploiement, générée automatiquement sur chaque PR
- **Blue-green deployment** : promouvoir un déploiement preview vers la production depuis l'interface Vercel ("Promote to Production") sans rebuild

### Configuration initiale

```bash
pnpm add -g vercel    # installer la CLI Vercel
vercel login          # s'authentifier
vercel                # créer/lier le projet, récupérer le Project ID
```

Secrets nécessaires dans la CI :
- `VERCEL_TOKEN` : token d'accès personnel
- `VERCEL_ORG_ID` : identifiant d'organisation ou d'utilisateur
- `VERCEL_PROJECT_ID` : identifiant du projet Vercel

## Pipeline de livraison continue

### Déploiement de production

- Déclenché manuellement (`workflow_dispatch` sur GitHub, job `when: manual` sur GitLab)
- Réutilise l'artifact de build produit par le job `build`
- Déploie sur l'environnement production Vercel

### Déploiement de preview

- Déclenché automatiquement à l'ouverture d'une PR / MR
- Déploie sur un environnement preview Vercel
- URL de preview unique, différente de la production

## Correspondances GitHub Actions / GitLab CI

| Concept | GitHub Actions | GitLab CI |
|---|---|---|
| Fichier pipeline | `.github/workflows/*.yml` | `.gitlab-ci.yml` |
| Secret | Repository / environment secret | CI/CD variable |
| Déclenchement manuel | `workflow_dispatch` | job `when: manual` |
| Validation avant prod | `environment` avec approbation | job manuel |
| PR/MR trigger | event `pull_request` | `merge_request_event` |
| Artifact | `actions/upload-artifact` | `artifacts:` |

## Cheat sheet

```yaml
# GitHub Actions — déploiement de production manuel
on:
  workflow_dispatch:

jobs:
  deploy-prod:
    environment: production   # protection avec approbation requise
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build
      - run: vercel deploy --prebuilt --prod --token=${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}

# GitHub Actions — déploiement de preview sur PR
on:
  pull_request:

jobs:
  deploy-preview:
    steps:
      - run: vercel deploy --prebuilt --token=${{ secrets.VERCEL_TOKEN }}
        env:
          VERCEL_ORG_ID: ${{ secrets.VERCEL_ORG_ID }}
          VERCEL_PROJECT_ID: ${{ secrets.VERCEL_PROJECT_ID }}
```
