# Lab 6 - Azure Static Web Apps

## Objectif

Comprendre le déploiement d'une application statique Nuxt sur Azure Static Web Apps, avec des environnements QA et production, et un pipeline CD non interactif.

## Principales étapes

- prise en main d'Azure et de l'Azure CLI
- création d'une ressource Azure Static Web App pour la production
- identification du bon artifact de build (`.output/public/`)
- création d'un environnement QA distinct
- récupération de tokens de déploiement non interactifs
- adaptation du pipeline pour déployer QA automatiquement et production avec validation humaine

## Bonnes pratiques du lab

- utiliser des conventions de nommage cohérentes entre QA et production
- séparer build et déploiement
- réutiliser un artifact de build existant en production
- ne pas dépendre d'une authentification interactive dans la CI

## Outils et commandes clés

- `az login` / `az account set -s <subscription>` : authentification Azure CLI
- `az group create` : création de groupe de ressources
- `az staticwebapp create` : création d'une Azure Static Web App
- `az staticwebapp secrets list -n <name> --query "properties.apiKey"` : récupération du token de déploiement
- `pnpm generate` ou `pnpm build` selon les scripts du projet pour générer le site statique
- `.output/public/` : dossier à déployer sur Azure Static Web Apps
- `npx @azure/static-web-apps-cli deploy .output/public --app-name ... --resource-group ... --deployment-token ...` : déploiement QA via SWA CLI
- `Azure/static-web-apps-deploy@v1` : action GitHub pour déployer en production

## Pipeline CD

Le pipeline doit :

- builder l'application en mode statique
- uploader `.output/public/` comme artifact
- déployer automatiquement sur l'environnement QA
- déployer en production à partir du même artifact
- protéger la production par une validation humaine ou un environnement protégé

## Livrables observés

- `deploy-azure.yml` : workflow GitHub Actions avec jobs `build`, `qa`, `production`
- `script.azcli` : script Azure CLI de création de groupe de ressources et de Static Web App en QA
- `invite-users.ps1` : script PowerShell complémentaire potentiellement utilisé pour gestion des utilisateurs ou accès

## Cheat sheet

```bash
az login
az account set -s <subscription-id>
az group create -n rg-vue2048-<env> -l "France Central" --tags Class=EI8IT213
az staticwebapp create -n stapp-vue2048-<env> -g <resource-group>
az staticwebapp secrets list -n <name> --query "properties.apiKey"
```

```yaml
# Extrait pipeline GitHub Actions
- uses: actions/upload-artifact@v6
  with:
    name: 2048-app-build
    path: .output/public/

- uses: actions/download-artifact@v6
  with:
    name: 2048-app-build
    path: .output/public
```

```yaml
# Déploiement QA via SWA CLI
run: npx @azure/static-web-apps-cli deploy .output/public --app-name 2048-app --resource-group 2048-app-rg --deployment-token ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
```

```yaml
# Déploiement production via action Azure
uses: Azure/static-web-apps-deploy@v1
with:
  azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
  action: "upload"
  app_location: ".output/public"
```
