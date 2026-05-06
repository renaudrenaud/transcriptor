# ADR-004 — Patch de sécurité sur l'image upstream

**Statut :** Accepté  
**Date :** 2026-05-06

## Contexte

Le scan Harbor de l'image `ghcr.io/kth8/whisper-server-vulkan` révèle des CVEs de sévérité moyenne et basse. Parmi ceux-ci, plusieurs ont un correctif disponible dans les dépôts Ubuntu :

| Package | CVE(s) | Version fixée |
|---|---|---|
| `libssl3t64` | CVE-2026-31790, CVE-2026-28387/88/89/90, CVE-2026-31789 | `3.0.13-0ubuntu3.9` |
| `libgnutls30t64` | CVE-2025-14831, CVE-2025-9820 | `3.8.3-1.1ubuntu3.5` |
| `libsystemd0` + `libudev1` | CVE-2026-29111 | `255.4-1ubuntu8.14` |
| `libcap2` | CVE-2026-4878 | `1:2.66-5ubuntu2.4` |
| `sed` | CVE-2026-5958 | `4.9-2ubuntu0.24.04.1` |

## Décision

Introduire un `Dockerfile` minimal qui hérite de l'image upstream et applique un `apt-get upgrade` ciblé sur les packages concernés. Le `docker-compose.yml` passe de `image:` à `build: .`.

## Justification

- **Correctifs disponibles** : ces CVEs ont une version fixée publiée — ne pas les appliquer serait négligent.
- **Impact minimal** : seuls les packages vulnérables sont mis à jour, pas de recompilation de whisper.cpp.
- **Image upstream préservée** : on n'abandonne pas l'image pré-compilée (ADR-003), on la patch.

## Alternatives écartées

| Alternative | Raison du rejet |
|---|---|
| Attendre une mise à jour de l'image upstream | Délai inconnu, CVEs non traités en production |
| Recompiler depuis les sources | Abandonné en ADR-003 (connexion GitHub bloquée en container) |

## Conséquences

- Un `docker compose build` est nécessaire après chaque mise à jour du `Dockerfile`.
- Les CVEs sans correctif disponible (`tar`, `libc6`, `dpkg`, `util-linux`…) restent dans l'image — à surveiller.
- À chaque nouvelle version de l'image upstream, réévaluer si les patches sont toujours nécessaires.
