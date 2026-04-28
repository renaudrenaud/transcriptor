# ADR-002 — Backend GPU : Vulkan

**Statut :** Accepté  
**Date :** 2026-04-27

## Contexte

La machine hôte dispose d'un GPU AMD. whisper.cpp supporte plusieurs backends GPU : CUDA, Vulkan, Metal, ROCm.

## Décision

Utiliser le backend Vulkan pour l'accélération GPU AMD. En pratique, l'image pré-compilée `ghcr.io/kth8/whisper-server-vulkan` est compilée avec `-DGGML_VULKAN=1` (voir ADR-005).

## Justification

- **Compatibilité AMD** : CUDA est exclusif NVIDIA. Vulkan est le backend GPU générique supporté nativement par les GPUs AMD via les pilotes `amdgpu` standard.
- **Pilotes standard** : Vulkan fonctionne avec les pilotes Mesa/AMDGPU présents dans la plupart des distributions Linux, sans paquet propriétaire supplémentaire.
- **Stabilité** : ROCm (alternative AMD) nécessite une installation spécifique complexe et des versions de noyau précises.
- **Passthrough Docker simple** : `--device /dev/dri` suffit pour exposer le GPU AMD au container.

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| CUDA | GPU exclusivement NVIDIA |
| ROCm | Installation complexe, dépendances lourdes, versions kernel contraintes |
| CPU seul | Trop lent pour large-v3, pas acceptable pour des fichiers longs |

## Conséquences

- Le host doit avoir Vulkan fonctionnel (`vulkaninfo` doit retourner un GPU AMD).
- `/dev/kfd` et `/dev/dri` doivent être passés au container.
- Performances inférieures à CUDA sur GPU NVIDIA, mais excellentes sur AMD — ex. ~2 min pour 1h d'audio sur AMD AI 395 (Strix Halo).
