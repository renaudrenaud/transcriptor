# ADR-003 — Image pré-compilée au lieu de build from source

**Statut :** Accepté  
**Date :** 2026-04-27

## Contexte

Compiler whisper.cpp depuis les sources dans un container est impraticable : cela nécessite un git clone de GitHub et le téléchargement de nombreux paquets Debian, ce qui est long et dépendant d'une connexion fiable.

## Décision

Utiliser l'image pré-compilée `ghcr.io/kth8/whisper-server-vulkan:latest` plutôt que de compiler depuis les sources.

## Justification

- **Pas de compilation** : `docker pull` suffit, pas de git clone ni de cmake.
- **Déjà optimisée** : compilée avec Vulkan, sans exigence AVX (compatible hardware plus ancien).
- **API HTTP** : expose `/v1/audio/transcriptions` compatible OpenAI Whisper API — facilite l'intégration future.
- **Maintenance déléguée** : les mises à jour whisper.cpp sont gérées par le mainteneur de l'image.
- **Modèle embarqué** : pas de téléchargement ni de montage séparé nécessaire.

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| Build from source | Long, fragile, dépendant du réseau au moment du build |
| Image officielle whisper.cpp | Pas de support Vulkan précompilé disponible |

## Conséquences

- Dépendance à une image tierce (`ghcr.io/kth8`) — suivre les mises à jour.
- L'interface est une **API HTTP** (port 8080) plutôt qu'un CLI direct — `transcribe.sh` encapsule l'appel curl.
- `/dev/kfd` et `/dev/dri` doivent être passés au container pour l'accès GPU AMD.
