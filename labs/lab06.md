# Lab 06

## Objectifs du TP

- Découvrir Azure et Azure Static Web Apps
- Déployer l'application 2048 sur Azure en distinguant QA et production
- Mettre en place un pipeline de CD multi-environnements
- Faire des choix de conception raisonnés plutôt que suivre une recette unique

## Pré-requis

- Avoir réalisé le Lab 05, ou disposer d'un pipeline CI fonctionnel
- Avoir mis à jour son dépôt local par rapport au dépôt d'origine (`git pull upstream main`)
- Créer une branche `lab06` à partir de `main`
- Disposer d'un compte Azure avec une souscription active (par exemple `Azure for Students`)

Ce lab peut être réalisé **au choix** avec :
- **GitHub Actions**
- **GitLab CI**

Le comportement attendu est le même dans les deux cas. Seule la syntaxe du pipeline change.

> Faire des commits réguliers avec des messages explicites. Tester chaque étape avant de passer à la suivante.

## Correspondances entre plateformes

| Concept | GitHub Actions | GitLab CI |
| --- | --- | --- |
| Secret de déploiement | Repository secret / environment secret | CI/CD variable |
| Environnement QA | `environment: qa` | `environment: name: qa` |
| Environnement de production | `environment: production` | `environment: name: production` |
| Validation humaine avant production | environment protégé avec approbation ou workflow manuel | job manuel (`when: manual`) |
| Artifact généré par le build | `actions/upload-artifact` | `artifacts` |

## 0. Prise en main d'Azure

1. Connectez-vous au portail Azure.
2. Vérifiez qu'une souscription active est disponible.
3. Installez l'[Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) et assurez-vous de pouvoir vous authentifier depuis le terminal.

### Attendu

Vous devez être capable d'identifier la souscription utilisée pour le reste du TP et d'interroger votre compte depuis la ligne de commande.

## 1. Provisionner un environnement de production

Créez un premier environnement Azure dédié à la production avec **au minimum** :

- un groupe de ressources
- une Azure Static Web App
- un plan `Free`

Vous êtes libres de choisir votre convention de nommage, mais elle doit être :

- cohérente entre les environnements
- explicite sur le rôle de la ressource
- réutilisable ensuite pour la QA

Cette première ressource peut être créée :

- soit depuis le portail Azure pour découvrir l'interface
- soit via l'Azure CLI

### Attendus

- les ressources créées et leur nommage sont cohérents
- la ressource de production existe bien

## 2. Identifier la bonne stratégie de build et de déploiement local

Avant d'automatiser quoi que ce soit, déterminez comment cette application Nuxt doit être préparée pour un hébergement statique sur Azure Static Web Apps.

Votre travail consiste à :

1. Installer la SWA CLI
2. Déterminer quelle commande de build est adaptée au projet
3. Utiliser le dossier **`.output/public/`** comme artifact à déployer sur Azure
4. Réaliser un premier déploiement manuel
5. Vérifier la différence entre un déploiement de preview et un déploiement de production

### Attendus

- vous utilisez correctement le dossier **`.output/public/`** pour ce projet
- un déploiement de preview a été réalisé
- un déploiement de production a été réalisé

### Indices

- Regardez les scripts disponibles dans `package.json`
- Vérifiez la sortie produite après génération du site
- Pour ce dépôt, le dossier à déployer est **`.output/public/`**

## 3. Créer un environnement QA

Créez un second environnement Azure dédié à la QA en vous appuyant cette fois-ci sur l'Azure CLI.

Cet environnement doit reprendre la même logique que la production :

- même type de ressource
- même convention de nommage
- différenciation claire QA / production

### Attendus

- la ressource QA existe bien
- son URL publique est identifiable
- votre choix de nommage est cohérent avec la production

## 4. Préparer l'authentification de déploiement pour la CI/CD

Le pipeline de CI/CD ne doit pas reposer sur une authentification interactive.

Vous devez donc :

1. Utiliser un **deployment token** pour déployer depuis la CI vers Azure Static Web Apps
2. Récupérer un token pour la QA et un token pour la production
3. Les stocker sur votre plateforme de CI avec **le même nom de variable**, mais une valeur différente selon l'environnement

## 5. Adapter le pipeline de CD

Faites évoluer votre pipeline pour satisfaire les contraintes suivantes :

1. L'application est préparée pour un hébergement statique
2. Le résultat du build est publié comme artifact, en utilisant **`.output/public/`**
3. Le déploiement **QA** est automatisé
4. Le déploiement **production** réutilise le même artifact que la QA
5. Le déploiement **production** exige une validation humaine

Vous êtes libres sur :

- le découpage précis en jobs
- les noms des jobs
- le déclencheur exact du déploiement QA
- la façon d'organiser les scripts de déploiement

### Attendus

Le pipeline doit montrer que vous savez :

- séparer build et déploiement
- réutiliser un artifact plutôt que rebuild en production
- distinguer les environnements QA et production
- protéger la production par une intervention humaine

### Indices

- La SWA CLI accepte un token de déploiement
- Utilisez le même nom de variable de secret dans tous les environnements, avec une valeur spécifique à chaque environnement
- Le pipeline doit déployer **`.output/public/`**, pas relancer un build implicite dans chaque job

## 6. Vérification fonctionnelle

Pour démontrer que votre pipeline fonctionne réellement :

1. Effectuez une modification **visible** dans l'application
2. Déclenchez le flux menant au déploiement QA
3. Vérifiez que cette version est bien visible sur l'environnement QA
4. Déclenchez ensuite le déploiement de production
5. Vérifiez que la même version est visible en production

### Attendus

La vérification doit permettre de montrer :

- que les deux environnements sont bien distincts
- que la production est mise à jour uniquement après validation
- que le build déployé en production correspond bien à celui validé en QA

## 7. Compétences visées

À l'issue du lab, vous devriez être capable de :

- créer et organiser deux Azure Static Web Apps distinctes
- choisir le bon mode de build pour ce projet Nuxt
- identifier le bon artifact à déployer
- mettre en place un déploiement CI/CD non interactif
- automatiser la QA
- protéger la production

## 8. Pour aller plus loin

- factoriser le script de déploiement commun entre QA et production
- ajouter un nettoyage automatisé des ressources de test avec `az group delete`
- ajouter un déploiement de preview supplémentaire pour les Pull Requests / Merge Requests
- comparer les différences entre un déploiement Vercel (Lab 05) et un déploiement Azure Static Web Apps

## Aides minimales autorisées

Vous pouvez vous appuyer sur :

- la documentation Azure Static Web Apps
- la documentation de la SWA CLI
- les scripts du projet

En revanche, le choix précis :

- des commandes finales
- du nommage des ressources
- de la structure du pipeline
- de l'organisation des environnements

fait partie du travail attendu.
