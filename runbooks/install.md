# Runbook — Installation

Deux voies d'installation selon l'accès disponible :

| Voie | Source de l'image | Accès requis |
|------|-------------------|--------------|
| [A — Git clone](#voie-a--git-clone-source-publique) | `ghcr.io/kth8/whisper-server-vulkan` | Public |
| [B — Harbor](#voie-b--harbor-registre-privé) | Registre Harbor interne | Accès Harbor requis |

---

## Prérequis communs

### Docker + Docker Compose

```bash
docker --version
docker compose version
```

Si absent : https://docs.docker.com/engine/install/

### GPU AMD + Vulkan

```bash
vulkaninfo --summary
```

La sortie doit mentionner ton GPU AMD. Si `vulkaninfo` est absent :

```bash
sudo apt-get install vulkan-tools mesa-vulkan-drivers
```

### Accès /dev/kfd et /dev/dri

```bash
ls -la /dev/kfd /dev/dri/renderD128
```

Si permission refusée :

```bash
sudo usermod -aG render,video $USER
# Puis déconnexion/reconnexion
```

Si `/dev/kfd` est absent, le module `amdgpu` n'est pas chargé :

```bash
lsmod | grep amdgpu
```

---

## Voie A — Git clone (source publique)

Cette voie télécharge l'image directement depuis `ghcr.io`. Elle est accessible à tous sans compte particulier.

### Étape 1 — Cloner le projet

```bash
git clone <url-du-repo> transcriptor
cd transcriptor
```

### Étape 2 — Tirer l'image

```bash
docker compose pull
```

Le modèle est embarqué dans l'image — pas de téléchargement séparé nécessaire.

### Étape 3 — Démarrer

```bash
docker compose up -d
```

### Étape 4 — Vérifier que Vulkan est actif

```bash
docker compose logs whisper | grep -i vulkan
```

### Étape 5 — Tester

```bash
./transcribe.sh ~/Téléchargements/meeting.mp3
```

---

## Voie B — Harbor (registre privé)

> **Accès restreint.** Cette voie est réservée aux personnes disposant de credentials pour notre registre Harbor interne. Si vous n'avez pas de compte Harbor, utilisez la [Voie A](#voie-a--git-clone-source-publique).

Harbor héberge les deux images de l'application (`whisper` et `frontend`), auditées et scannées. Aucun git clone requis — tout vient du registre.

### Étape 1 — Se connecter au registre Harbor

```bash
docker login harbor-prod.atlog.io \
  --username <votre-login>
```

### Étape 2 — Créer le répertoire de travail

```bash
mkdir transcriptor && cd transcriptor
```

### Étape 3 — Créer le fichier `docker-compose.yml`

```yaml
services:
  whisper:
    image: harbor-prod.atlog.io/ia_tools/whisper-server-vulkan:1.4.0
    init: true
    devices:
      - /dev/kfd
      - /dev/dri
    read_only: true
    tmpfs:
      - /root/.cache/mesa_shader_cache
    volumes:
      - ~/models:/models:ro
    restart: unless-stopped

  frontend:
    image: harbor-prod.atlog.io/ia_tools/frontend:1.4.0
    ports:
      - "8765:80"
    volumes:
      - ./config.json:/usr/share/nginx/html/config.json:ro
    depends_on:
      - whisper
    restart: unless-stopped
```

### Étape 4 — Créer le fichier `config.json`

Ce fichier indique l'adresse du serveur Ollama utilisé pour la génération de compte rendu :

```json
{
  "ollamaHost": "http://localhost:11434"
}
```

Remplacer `localhost` par le nom ou l'IP de la machine Ollama si elle est distante (ex. `http://evo-x2:11434`).

### Étape 5 — Démarrer

```bash
docker compose up -d
```

### Étape 6 — Vérifier que Vulkan est actif

```bash
docker compose logs whisper | grep -i vulkan
```

### Étape 7 — Tester

```bash
# Interface web
open http://localhost:8765

# CLI (nécessite d'avoir transcribe.sh — récupérable depuis le repo git)
./transcribe.sh ~/Téléchargements/meeting.mp3
```

---

## Dépannage

### Le serveur ne démarre pas (`/dev/kfd` permission denied)

```bash
sudo usermod -aG render,video $USER
# Déconnexion/reconnexion obligatoire
```

### `No Vulkan devices found` dans les logs

```bash
# Vérifier depuis le host
vulkaninfo --summary

# Vérifier les permissions
stat /dev/dri/renderD128
stat /dev/kfd
```

### Port 8080 déjà utilisé

Modifier dans `docker-compose.yml` :

```yaml
ports:
  - "8181:8080"
```

### `permission denied` sur `/var/run/docker.sock`

L'utilisateur n'est pas dans le groupe `docker` :

```bash
sudo usermod -aG docker $USER
# Déconnexion/reconnexion obligatoire, ou pour la session courante :
newgrp docker
```

### Authentification Harbor échoue

Vérifier que votre compte a les droits `pull` sur le projet Harbor.
