# ADR-001 — Utilisation de whisper.cpp

**Statut :** Accepté  
**Date :** 2026-04-27

## Contexte

Besoin de transcription audio locale, sans dépendance à un service cloud, pour des fichiers audio de réunions en français.

## Décision

Utiliser [whisper.cpp](https://github.com/ggerganov/whisper.cpp), le portage C++ du modèle Whisper d'OpenAI.

## Justification

- **Local-first** : aucune donnée ne quitte la machine.
- **Performance** : implémentation C++ optimisée, avec support de backends GPU (CUDA, Vulkan, Metal).
- **Qualité** : accès aux mêmes modèles que l'implémentation Python originale (base → large-v3).
- **Légèreté** : pas de runtime Python ni de dépendances lourdes dans l'image finale.

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| API OpenAI Whisper | Données envoyées dans le cloud |
| faster-whisper (Python) | Runtime Python + CUDA, moins adapté à Vulkan/AMD |
| openai/whisper (Python) | Mêmes limitations, plus lent |

## Conséquences

- La compilation est gérée par le mainteneur de l'image pré-compilée (voir ADR-005) — pas de build local nécessaire.
- Les mises à jour de whisper.cpp dépendent des nouvelles versions de l'image `ghcr.io/kth8/whisper-server-vulkan`.
