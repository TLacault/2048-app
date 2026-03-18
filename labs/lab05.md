# Lab 05

## Objectifs du TP

- Se familiariser avec la livraison continue
- Déployer une application web sur une plateforme d'hébergement
- Mettre en place un déploiement de production et un déploiement de preview

Ce lab peut être réalisé **au choix** avec :
- **GitHub Actions**
- **GitLab CI**

Le comportement attendu est le même dans les deux cas. Seule la syntaxe du pipeline change.

## Pré-requis

- Avoir mis à jour son dépôt local par rapport au dépôt d'origine (`git pull upstream main`)
- Créer une branche `lab05` à partir de `main`
- Partir d'un pipeline CI fonctionnel issu des labs précédents, ou utiliser les pipelines minimaux fournis dans `deliverables/lab05`
  - **GitHub Actions** : `deliverables/lab05/0.github-actions.yaml`
  - **GitLab CI** : `deliverables/lab05/0.gitlabci.yaml`

> Tester chaque étape en exécutant le pipeline correspondant. Faire des commits réguliers avec des messages explicites. À la fin du TP, nettoyer l'historique si nécessaire.

## Correspondances entre plateformes

Pour ce lab, utiliser les équivalences suivantes :

| Concept | GitHub Actions | GitLab CI |
| --- | --- | --- |
| Fichier du pipeline | `.github/workflows/*.yml` | `.gitlab-ci.yml` |
| Secret / variable protégée | Repository secret / environment secret | CI/CD variable |
| Déclenchement manuel d'un pipeline / workflow | `workflow_dispatch` | pipeline manuel |
| Validation humaine avant un déploiement de production | workflow déclenché manuellement ou job protégé par un `environment` avec approbation | job manuel (`when: manual`) |
| Changement en revue | Pull Request | Merge Request |
| Déploiement de preview | `pull_request` | `merge_request_event` |
| Artifact produit par le build | `actions/upload-artifact` | `artifacts` |

## 1. Configuration d'un projet Vercel

- Aller sur https://vercel.com/ et créer un compte gratuit
- Dans les paramètres du compte :
  - récupérer l'identifiant d'organisation ou d'utilisateur
  - créer un token d'accès personnel et le conserver
- Installer la [CLI Vercel](https://vercel.com/docs/cli) en local avec `pnpm add -g vercel`
- Se connecter à Vercel avec la CLI
- Créer un projet Vercel pour l'application
- Vérifier dans l'interface Vercel que le projet existe et récupérer son identifiant (`Project ID`)

## 2. Adaptation du pipeline pour déployer sur Vercel

### 2.1 Configuration des secrets

Ajouter les secrets suivants sur votre plateforme de CI :
- `VERCEL_TOKEN`
- `VERCEL_ORG_ID`
- `VERCEL_PROJECT_ID`

Selon la plateforme choisie :
- **GitHub Actions** : ajouter ces valeurs dans les repository secrets ou environment secrets
- **GitLab CI** : ajouter ces valeurs dans `Settings > CI/CD > Variables`

### 2.2 Déploiement de production

Ajouter un job de déploiement de production qui :
- réutilise le package produit par l'étape de build
- déploie sur l'environnement **production** de Vercel
- nécessite une **intervention humaine** avant son exécution

Selon la plateforme choisie :
- **GitHub Actions** : deux approches sont acceptées
  - un workflow de déploiement de production déclenché manuellement avec `workflow_dispatch`
  - un job de déploiement associé à un `environment` protégé demandant une approbation avant exécution
- **GitLab CI** : utiliser un job manuel avec `when: manual`.

Tester ensuite ce job et vérifier que l'application est accessible sur l'URL de production.

### 2.3 Déploiement de preview

Ajouter un job de déploiement de preview qui :
- réutilise le package produit par l'étape de build
- déploie sur un environnement **preview** Vercel
- s'exécute uniquement lorsqu'une proposition de fusion est ouverte
  - **GitHub Actions** : lors d'une `pull_request`
  - **GitLab CI** : lors d'une `merge_request_event`

### 2.4 Vérification du déploiement de preview

Pour tester ce comportement :
- créer une nouvelle branche à partir de `lab05`
- effectuer une modification **visible** dans l'application
  - par exemple dans `app/components/game/Header.vue`, remplacer `Score` par `My Score`
- ouvrir une Pull Request ou une Merge Request vers `lab05` ou `main` selon votre organisation
- vérifier que le pipeline de preview se lance bien
- vérifier que l'application modifiée est accessible sur une URL de preview différente de l'URL de production

### 2.5 Blue-green deployment

Appliquer ensuite un blue-green deployment en promouvant le déploiement de preview vers la production depuis l'interface Vercel :
- [promote to production](https://vercel.com/docs/deployments/managing-deployments#promote-a-deployment-from-preview-to-production)

Vérifier que :
- l'URL de production sert bien la nouvelle version de l'application
- l'ancienne version n'est plus celle exposée en production

> Lire la [documentation Vercel sur les environnements](https://vercel.com/docs/concepts/deployments/environments) pour bien distinguer les notions de preview et de production.

## 3. Attendus

Votre implémentation doit au minimum :
- produire un artifact de build
- imposer une validation humaine avant le déploiement en production
- déployer automatiquement en preview lors d'une proposition de fusion
- réutiliser les secrets ou variables de la plateforme choisie

Selon la plateforme utilisée :
- **GitHub Actions** : utiliser des Pull Requests et les secrets GitHub
- **GitLab CI** : utiliser des Merge Requests et les variables CI/CD GitLab

## 4. Pour aller plus loin

- Ajouter un second déploiement sur [Netlify](https://www.netlify.com/), en plus de Vercel
- Reproduire la même logique de déploiement sur l'autre plateforme CI que celle choisie initialement
  - si vous avez fait le lab avec GitHub Actions, produire aussi une version GitLab CI
  - si vous avez fait le lab avec GitLab CI, produire aussi une version GitHub Actions
- Comparer les deux implémentations :
  - syntaxe des triggers
  - gestion des secrets
  - gestion des artifacts
  - ergonomie du déploiement manuel