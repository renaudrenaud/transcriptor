# Runbook — Installation

## Prérequis système

### 1. Docker + Docker Compose

```bash
docker --version
docker compose version
```

Si absent : https://docs.docker.com/engine/install/

### 2. GPU AMD + Vulkan

```bash
vulkaninfo --summary
```

La sortie doit mentionner ton GPU AMD. Si `vulkaninfo` est absent :

```bash
sudo apt-get install vulkan-tools mesa-vulkan-drivers
```

### 3. Accès /dev/kfd et /dev/dri

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

## Installation

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

### Étape 3 — Démarrer le serveur

```bash
docker compose up -d
```

### Étape 4 — Vérifier que Vulkan est actif

```bash
docker compose logs whisper | grep -i vulkan
```

### Étape 5 — Tester

```bash
mkdir -p ~/Téléchargements/transcription
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
