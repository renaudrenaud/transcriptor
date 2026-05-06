# Sécurité

## Posture générale

Transcriptor est un service local : le serveur whisper écoute sur `localhost:8080` et n'est pas exposé sur le réseau. L'audio ne quitte jamais la machine. Cette contrainte réduit significativement la surface d'attaque.

## Scan de vulnérabilités

L'image `ghcr.io/kth8/whisper-server-vulkan` est scannée via Harbor. Résultats du scan du 2026-05-06 :

- **Critiques / Hautes** : aucune
- **Moyennes** : 23 CVEs — dont 5 avec correctif disponible, 18 sans correctif (upstream non patché)
- **Basses** : 11 CVEs — dont 5 avec correctif disponible, 6 sans correctif

### CVEs avec correctif disponible (Medium)

| CVE | Package | Version fixée |
|---|---|---|
| CVE-2026-4878 | `libcap2` | `1:2.66-5ubuntu2.4` |
| CVE-2025-14831, CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-31790 | `libssl3t64` | `3.0.13-0ubuntu3.9` |
| CVE-2026-29111 | `libsystemd0`, `libudev1` | `255.4-1ubuntu8.14` |
| CVE-2026-5958 | `sed` | `4.9-2ubuntu0.24.04.1` |

### CVEs avec correctif disponible (Low)

| CVE | Package | Version fixée |
|---|---|---|
| CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-28387/88/89/90, CVE-2026-31789 | `libssl3t64` | `3.0.13-0ubuntu3.9` |

## Décision

**Ces CVEs ne sont pas patchées activement** pour les raisons suivantes :

- Toutes de sévérité Medium ou Low — aucune Critical ni High.
- Le service est strictement local (`localhost`) — les vecteurs d'exploitation réseau sont bloqués par conception.
- Patcher via un `Dockerfile` wrapper introduit un coût de maintenance (rebuild à chaque mise à jour upstream) disproportionné au risque.

**Si le service venait à être exposé sur le réseau** (ex. déploiement sur un serveur partagé), il faudrait reconsidérer cette décision et appliquer les patches via un `Dockerfile` dédié.

## Mise à jour de l'image

Suivre les nouvelles versions de `ghcr.io/kth8/whisper-server-vulkan` — elles intègrent généralement les mises à jour de sécurité upstream :

```bash
docker compose pull
docker compose up -d
```
