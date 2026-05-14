# ADR-004 — Container frontend séparé (nginx)

**Statut :** Accepté  
**Date :** 2026-05-14

## Contexte

Le container `whisper` expose une API HTTP brute sur le port 8080. Pour offrir une interface utilisateur accessible depuis un navigateur, il faut un composant supplémentaire capable de servir des fichiers statiques et de proxifier les appels vers l'API.

## Décision

Ajouter un second container `frontend` basé sur `nginx:alpine`, qui :
- sert l'interface web (HTML/JS/CSS) sur le port 8765
- proxifie les requêtes `/api/*` vers `whisper:8080`
- n'expose pas directement le port 8080 du container `whisper` sur le réseau

## Justification

- **Séparation des responsabilités** : `whisper` fait de la transcription, `frontend` gère la présentation et le routage HTTP. Chaque container a un périmètre clair.
- **Sécurité** : le port 8080 de `whisper` n'est pas exposé à l'extérieur — seul nginx est accessible depuis le réseau.
- **Image tierce non modifiable** : `ghcr.io/kth8/whisper-server-vulkan` ne peut pas servir de fichiers statiques. Modifier son comportement nécessiterait de forker l'image, ce qui va à l'encontre de l'ADR-003.
- **Légèreté** : `nginx:alpine` (~27 Mo) est négligeable en comparaison de l'image whisper.
- **Optionnel pour la CLI** : le container `frontend` peut être omis si l'usage est exclusivement en ligne de commande (`docker compose up -d whisper`).

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| Exposer directement le port 8080 de whisper | Pas d'interface web, API non protégée accessible depuis le réseau |
| Intégrer un serveur web dans l'image whisper | Image tierce non modifiable (ADR-003) |
| Application web déportée (hors container) | Complexité de déploiement, rupture de l'approche "une commande pour démarrer" |

## Conséquences

- `docker compose up -d` démarre deux containers : `whisper` et `frontend`.
- Pour un usage CLI uniquement : `docker compose up -d whisper` suffit.
- Le timeout de transcription est configuré dans `frontend/nginx.conf` (`proxy_read_timeout`), pas dans `whisper`.
- L'image `frontend` est publiée dans Harbor (voir scripts `push-*.sh`) avec la même version que l'ensemble de la release.
