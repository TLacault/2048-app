# Lab 2 - Notes

## Cours

### Repository Remote

Le repository remote est une version hébergée du dépôt Git, souvent sur des plateformes comme GitHub, GitLab ou Bitbucket.
Il permet la collaboration entre plusieurs développeurs en centralisant le code source.


- `git remote add origin <url>` : lier dépôt local à distant
- `git remote -v` : vérifier les dépôts distants
- `git push -u origin main` : pousser branche locale vers distante et définir upstream
- `git clone <url>` : cloner dépôt distant localement
- `git pull` : récupérer et fusionner les changements du dépôt distant

```sh
git remote add upstream https://github.com/TechWatching/2048-app.git

git remote -v

origin  git@github.com:TLacault/2048-app.git (fetch)
origin  git@github.com:TLacault/2048-app.git (push)
upstream        https://github.com/TechWatching/2048-app.git (fetch)
upstream        https://github.com/TechWatching/2048-app.git (push)
```

## Git Merge vs Fetch + Rebase

- `git merge` : fusionne une branche dans la branche courante, créant un commit de fusion si nécessaire. Préserve l'historique des branches.
- `git fetch` : récupère les dernières modifications du dépôt distant sans les fusionner dans la branche courante.
- `git rebase` : applique les commits de la branche courante sur une autre branche, réécrivant l'historique pour créer une ligne de temps plus linéaire.


## Slidev

https://sli.dev/

Slidev est un outil open-source permettant de créer des présentations interactives et dynamiques en utilisant Markdown et Vue.js. Il offre une grande flexibilité pour personnaliser les diapositives avec du code, des animations et des composants Vue.

## Pourquoi une Pipeline plutôt qu'un script ?
Une pipeline CI/CD (Intégration Continue / Déploiement Continu) offre plusieurs avantages par rapport à un simple script :
1. **Automatisation** : Les pipelines CI/CD automatisent le processus de construction, de test et de déploiement, réduisant ainsi les erreurs humaines et accélérant le cycle de développement.
2. **Intégration avec des outils** : Les pipelines CI/CD s'intègrrent facilement avec des outils de gestion de code source, de suivi des bugs et de déploiement, facilitant ainsi la gestion du cycle de vie du développement logiciel.
3. **Contrôle de version** : Les pipelines CI/CD permettent de suivre les modifications du code et de gérer les versions,   ce qui est essentiel pour les projets collaboratifs.
4. **Tests automatisés** : Les pipelines CI/CD intègrent souvent des tests automatisés, garantissant que le code est testé à chaque modification, ce qui améliore la qualité du logiciel.
5. **Déploiement continu** : Les pipelines CI/CD permettent un déploiement continu, ce qui signifie que les modifications validées peuvent être automatiquement déployées en production, réduisant ainsi le temps de mise sur le marché.
6. **Scalabilité** : Les pipelines CI/CD peuvent être facilement adaptées pour gérer des projets de différentes tailles et complexités, offrant une flexibilité aux équipes de développement.
7. **Visibilité et rapports** : Les pipelines CI/CD fournissent des rapports détaillés sur le processus de construction, de test et de déploiement, offrant une meilleure visibilité sur l'état du projet.

En résumé, une pipeline CI/CD offre une approche plus structurée, automatisée et intégrée pour gérer le cycle de vie du développement logiciel par rapport à un simple script.
