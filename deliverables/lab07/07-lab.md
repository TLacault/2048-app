# Lab 7 - Infrastructure as Code avec Pulumi

## Objectif

Apprendre à provisionner une infrastructure Azure avec Pulumi et à gérer les ressources Azure Static Web Apps comme du code.

## Principales étapes

- installation de Pulumi
- initialisation d'un projet Pulumi dans le dossier `infra`
- création d'une stack Pulumi unique et d'un programme IAC
- provisionnement d'une ressource Azure Static Web App depuis le code
- exposition de outputs utiles de la stack
- récupération et protection du token de déploiement

## Concepts clés

- `Pulumi.yaml` : définition du projet Pulumi
- `Pulumi.<stack>.yaml` : configuration de la stack (valeurs et secrets)
- programme Pulumi (`index.ts`) : code qui décrit les ressources
- `pulumi up` : applique les changements d'infrastructure
- `pulumi stack output` : affiche les outputs de la stack
- secret Pulumi : données chiffrées dans l'état, utilisées pour tokens et secrets

## Infrastructure créée

Le code présent utilise :

- `azure_native.authorization.getClientConfigOutput()` pour récupérer le contexte Azure
- `azure_native.resources.ResourceGroup.get(...)` pour réutiliser un groupe de ressources existant
- `azure_native.web.StaticSite` pour créer une Azure Static Web App
- `azure_native.web.listStaticSiteSecretsOutput(...)` pour récupérer le token de déploiement

## Bonnes pratiques du lab

- utiliser un nom de stack unique pour isoler les environnements
- stocker les tokens et sorties sensibles comme secrets Pulumi
- vérifier la ressource créée depuis le portail Pulumi et le portail Azure
- bâtir l'infrastructure comme un code versionné, pas via des actions manuelles

## Livrables observés

- `deliverables/lab07/index.ts` : programme Pulumi Typescript qui crée une Static Web App
- la stack génère des outputs : `resourceGroupName` et `deploymentToken`
- `deploymentToken` est marqué comme secret via `pulumi.secret(...)`

## Cheat sheet

```ts
import * as pulumi from "@pulumi/pulumi";
import * as azure_native from "@pulumi/azure-native";

const clientConfig = azure_native.authorization.getClientConfigOutput();
const subscriptionId = clientConfig.apply(config => config.subscriptionId);
const id = pulumi.interpolate`/subscriptions/${subscriptionId}/resourceGroups/rg-lab7`;

const resourceGroup = azure_native.resources.ResourceGroup.get("rg-lab7", id);

const staticSite = new azure_native.web.StaticSite("staticSite", {
  branch: "master",
  name: pulumi.interpolate`stapp-2048-app-${pulumi.getStack()}`,
  repositoryUrl: "https://github.com/placeholder/placeholder",
  location: "westeurope",
  resourceGroupName: resourceGroup.name,
  sku: { name: pricing, tier: pricing },
});

const listStaticSiteSecretsOutput = azure_native.web.listStaticSiteSecretsOutput({
  resourceGroupName: resourceGroup.name,
  name: staticSite.name,
});

export const deploymentToken = pulumi.secret(listStaticSiteSecretsOutput.apply(secrets => secrets?.properties?.apiKey));
```

```bash
pulumi new azure-typescript -s <org/project/stack> -n <project-name>
pulumi up
pulumi stack output --show-secrets
pulumi secret <value>
```
