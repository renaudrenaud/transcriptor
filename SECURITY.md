# Sécurité

## Posture générale

Transcriptor est un service local : le serveur whisper écoute sur `localhost:8080` et n'est pas exposé sur le réseau. L'audio ne quitte jamais la machine. Cette contrainte réduit significativement la surface d'attaque.

---

## Historique des scans

| Date | Image | Sévérité | CVE | Action |
|------|-------|----------|-----|--------|
| 2026-05-17 | `frontend:1.5.0` | Moyenne | CVE-2025-14017, CVE-2025-14524, CVE-2025-14819, CVE-2026-1965, CVE-2026-3783, CVE-2026-3784, CVE-2026-3805 (curl/libcurl) | ✅ Corrigé — apk upgrade dans Dockerfile |
| 2026-05-15 | `frontend:1.4.0` | Haute | CVE-2026-27135 (nghttp2-libs) | ✅ Corrigé — rebuild nginx:alpine |
| 2026-05-15 | `frontend:1.4.0` | Moyenne | CVE-2026-4367 (libxpm) | ✅ Corrigé — rebuild nginx:alpine |
| 2026-05-15 | `frontend:1.4.0` | Moyenne | CVE-2026-34743 (xz-libs) | ✅ Corrigé — rebuild nginx:alpine |
| 2026-05-06 | `whisper-server-vulkan` | Moyenne | CVE-2026-4878, CVE-2025-14831, CVE-2025-9820, CVE-2026-31790, CVE-2026-29111, CVE-2026-5958 | ⏸ Non patchées — service local, risque acceptable |
| 2026-05-06 | `whisper-server-vulkan` | Basse | CVE-2025-9820, CVE-2026-28387/88/89/90, CVE-2026-31789 | ⏸ Non patchées — service local, risque acceptable |

---

## État courant par image

### `frontend` (nginx:alpine)

Scan du **2026-05-17** — `frontend:1.5.1`, rebuild avec `apk upgrade --no-cache` :

- **Critiques / Hautes** : aucune
- **Moyennes** : 7 CVEs `curl`/`libcurl` corrigées (`8.17.0-r1` → `8.19.0-r0`)

`apk upgrade --no-cache` ajouté dans le Dockerfile — garantit que tous les packages Alpine sont à jour à chaque rebuild, sans dépendre du tag `nginx:alpine` seul.

### `whisper-server-vulkan` (ghcr.io/kth8)

Scan du **2026-05-06** :

- **Critiques / Hautes** : aucune
- **Moyennes** : 23 CVEs — dont 5 avec correctif disponible, 18 sans correctif (upstream non patché)
- **Basses** : 11 CVEs — dont 5 avec correctif disponible, 6 sans correctif

#### CVEs avec correctif disponible (Medium)

| CVE | Package | Version fixée |
|---|---|---|
| CVE-2026-4878 | `libcap2` | `1:2.66-5ubuntu2.4` |
| CVE-2025-14831, CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-31790 | `libssl3t64` | `3.0.13-0ubuntu3.9` |
| CVE-2026-29111 | `libsystemd0`, `libudev1` | `255.4-1ubuntu8.14` |
| CVE-2026-5958 | `sed` | `4.9-2ubuntu0.24.04.1` |

#### CVEs avec correctif disponible (Low)

| CVE | Package | Version fixée |
|---|---|---|
| CVE-2025-9820 | `libgnutls30t64` | `3.8.3-1.1ubuntu3.5` |
| CVE-2026-28387/88/89/90, CVE-2026-31789 | `libssl3t64` | `3.0.13-0ubuntu3.9` |

---

## Politique de traitement

**`whisper-server-vulkan`** — CVEs non patchées activement :

- Toutes de sévérité Medium ou Low — aucune Critical ni High.
- Le service est strictement local (`localhost`) — les vecteurs d'exploitation réseau sont bloqués par conception.
- Patcher via un `Dockerfile` wrapper introduit un coût de maintenance disproportionné au risque.

**`frontend`** — CVEs patchées systématiquement :

- L'image `nginx:alpine` est rebuildée dès qu'une CVE Haute ou Critique est détectée.
- Processus : rebuild → scan Harbor local → validation → push test/prod.

**Si le service venait à être exposé sur le réseau** (ex. déploiement sur un serveur partagé), il faudrait reconsidérer la politique whisper et appliquer les patches via un `Dockerfile` dédié.

---

## Mise à jour des images

```bash
# whisper — suivre les nouvelles versions upstream
docker compose pull
docker compose up -d

# frontend — rebuild sur nginx:alpine mis à jour
docker pull nginx:alpine
docker build --no-cache --build-arg VERSION=$(cat VERSION) -t frontend:$(cat VERSION) ./frontend/
bash push-test.sh   # valider le scan Harbor
bash push-prod.sh
```
