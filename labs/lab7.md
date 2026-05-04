# Lab 7

## Objectifs du TP

- Découvrir l'Infrastructure as code à travers l'utilisation de Pulumi
- Provisionner un environnement contenant un groupe de resources et une Azure Static Web App

## Pré-requis

- Avoir accepté l'invitation reçue à l'organisation Pulumi
- Une souscription Azure (utiliser celle précédemment créée pour les autres labs)
- Répertoire mis à jour par rapport au dépôt d'origine (`git pull upstream main`)
- Azure CLI installée (cf lab 6)
- Environnement (SDK, runtime, outillage, ...) correspondant au langage qui sera utilisé pour implémenter l'infrastructure (Node.js ou SDK .NET par exemple)

## Mise en place

1. Installer Pulumi en suivant la [documentation](https://www.pulumi.com/docs/get-started/install/)
2. Se connecter à son compte Azure avec l'Azure CLI (`az login`)
3. Créer un nouveau dossier infra à la racine du répertoire Git
4. Dans le dossier infra initialiser un projet dans le langage de son choix avec la commmande pulumi new, par exemple `pulumi new azure-typescript -s teachingiac/an-cb-vue-2048/dev -n an-cb-vue-2048`.
  - `azure-typescript` correspond au template typescript mais d'autres sont disponibles (voir la liste avec la commande `pulumi new -l`)
  - `teachingiac/an-cb-vue-2048/dev` correspond à `organisationName/projectName/stackName`
  - `an-cb-vue-2048` correspond au nom de projet, bien penser à nommer de manière unique et identifiable
  - pour travailler chacun sur sa stack, il est possible de spécifier un nom de stack différent, `teachingiac/an-cb-vue-2048/dev-an` par exemple


## Prise en main de Pulumi

1. Ouvrir le répertoire dans un IDE pour visualiser la structure du projet et comment est décrite l'infrastructure dans le langage choisi.
 - Pulumi.yaml défini le projet
 - Pulumi.dev.yaml (où dev est le nom de la stack) contient les valeurs de configurations pour la stack
 - Les fichiers de code (index.ts par exemple) correspondent au programme Pulumi qui défnit les ressources de la stack
2. Exécuter la commande `pulumi up` pour provisionner l'infrastructure du template.
 - La prévisualisation montre les ressources correspondantes au code qui vont être provisionnées par Pulumi
 - Accepter l'update proposée
 - Se rendre sur l'URL indiquée pour suivre le déploiement sur le site Pulumi
3. Parcourir les différents onglets de la stack sur l'application Pulumi :
- L'onglet Overview indique les différents éléments sur la stack
- L'onglet Activity permet de consulter les différents déploiements d'infrastructure (avec les logs détaillées)
- L'onglet Resources permet de voir la liste et le graphe des ressources de la stack
4. Utiliser les liens disponibles dans l'onglet Resources pour vérifier quelles ressources ont été créées dans Azure

## Création de l'infrastructure pour vue-2048

Le but de cette partie va être de créer l'infrastructure Azure pour le projet vue-2048 via Pulumi.
Lors des précédents Labs, les environnements QA et Prod ont déjà été créés (manuellement ou via l'Azure CLI), on va ici créer un environnement azure que l'on appelera Preprod.

1. Modifier le programme Pulumi pour qu'il crée l'infrastructure Azure nécessaire à vue-2048

> 💡 La ressource correspondant à une Azure Static Web App se nomme StaticSite. S'aider de la [documentation](https://www.pulumi.com/registry/packages/azure-native/api-docs/web/staticsite/) et de l'autocomplétion pour trouver le code à écrire avec les bons paramètres. A noter qu'il est nécesaire de spécifier le paramètre `repositoryUrl` avec une chaine vide.

2. Appliquer les changements d'infrastructure avec la commande `pulumi up`.

> 💡 On peut utiliser également la commande `pulumi watch` si l'on veut que l'infrastructure soit automatiquement provisionnée à chaque enregistrement du code. On pourra l'utiliser pour la suite des instructions, sinon il est sous-entendu que l'on appliquera les modifications de l'infrastructure via `pulumi up` lorsque l'on modifiera le code.

3. Modifier le code pour que l'hostname de l'Azure Static Web App soit un [output](https://www.pulumi.com/learn/building-with-pulumi/stack-outputs/) de la stack.

4. Modifier le code pour ajouter le tag `Class` avec comme valeur `EI8IT213` à la resource Azure Static Web App.

5. Modifier le code pour ajouter un output contenant le deployment token de l'Azure Static Web App
 - on utilisera la méthode [`listStaticSiteSecretsOutput`](https://www.pulumi.com/registry/packages/azure-native/api-docs/web/liststaticsitesecrets/) pour récupérer ce token qui est contenu dans la clé `apiKey` de la propriété `properties` du résultat
 - on marquera l'output [en secret](https://www.pulumi.com/docs/intro/concepts/secrets/) pour que sa valeur soit encryptée dans l'état
 - on utilisera la commande `pulumi stack output --show-secrets` pour s'assurer que la bonne valeur a bien été récupérée