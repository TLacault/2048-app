# Pipeline CI/CD

## ACT

Outil qui permet de simuler des actions sur des pipelines CI/CD.

### Installation
``curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash``

### Utilisation
Lister les actions disponibles sur le pipeline CI/CD.
``./bin/act --list``
```
Stage  Job ID  Job name  Workflow name   Workflow file  Events
0      deploy  deploy    Lab03 Pipeline  main.yml       push,pull_request
```

Simuler une exécution locale d'une action sur le pipeline CI/CD.
``./bin/act push``
```
[Lab03 Pipeline/deploy] ⭐ Run Set up job
[Lab03 Pipeline/deploy] 🚀  Start image=node:16-buster-slim
[Lab03 Pipeline/deploy]   🐳  docker pull image=node:16-buster-slim platform= username= forcePull=true
[Lab03 Pipeline/deploy]   🐳  docker create image=node:16-buster-slim platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[Lab03 Pipeline/deploy]   🐳  docker run image=node:16-buster-slim platform= entrypoint=["tail" "-f" "/dev/null"] cmd=[] network="host"
[Lab03 Pipeline/deploy]   🐳  docker exec cmd=[node --no-warnings -e console.log(process.execPath)] user= workdir=
[Lab03 Pipeline/deploy]   ✅  Success - Set up job
[Lab03 Pipeline/deploy] ⭐ Run Main Checkout repository
[Lab03 Pipeline/deploy]   🐳  docker cp src=/home/tlacault/Documents/study/enseirb/semester_8/software/2048-app/. dst=/home/tlacault/Documents/study/enseirb/semester_8/software/2048-app
[Lab03 Pipeline/deploy]   ✅  Success - Main Checkout repository [64.108162ms]
[Lab03 Pipeline/deploy] ⭐ Run Main Greet the world
[Lab03 Pipeline/deploy]   🐳  docker exec cmd=[bash -e /var/run/act/workflow/1] user= workdir=
| Hello pipelines' world !
[Lab03 Pipeline/deploy]   ✅  Success - Main Greet the world [40.297365ms]
[Lab03 Pipeline/deploy] ⭐ Run Complete job
[Lab03 Pipeline/deploy] Cleaning up container for job deploy
[Lab03 Pipeline/deploy]   ✅  Success - Complete job
[Lab03 Pipeline/deploy] 🏁  Job succeeded
```

## Extension GitHub Actions for VS Code

Extension qui permet de créer, éditer et valider des workflows GitHub Actions directement depuis VS Code.

## Copilot Instructions

``.github/instructions.yml``

Ce fichier contient des instructions générale qui seront injectées dans le prompt / contexte.

## MATER.MD

Ce fichier contient des éléments de contexte qui seront injectés dans le prompt / contexte.

```
---
applyto: .github/workflows/*.yml
---
...
```

## AGENT.MD

```/src/agent.md```

Ces fichiers permettent de configurer le comportement de l'agent, notamment en lui donnant des instructions spécifiques à suivre pour réaliser une tâche.
