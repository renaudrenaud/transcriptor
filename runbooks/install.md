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

Harbor fournit des images auditées et scannées (voir `SECURITY.md`), hébergées sur notre réseau interne. Avantage principal sur le réseau local : pas de dépendance à `ghcr.io`.

### Étape 1 — Cloner le projet

```bash
git clone <url-du-repo> transcriptor
cd transcriptor
```

### Étape 2 — Configurer les credentials Harbor

Copier le fichier d'environnement et renseigner les valeurs :

```bash
cp .env.example .env
# Éditer .env : renseigner PROD_HARBOR_URL, PROD_HARBOR_USER, PROD_HARBOR_PASSWORD, PROD_HARBOR_PROJECT
```

### Étape 3 — Se connecter au registre Harbor

```bash
source .env
docker login "${PROD_HARBOR_URL}" \
  --username "${PROD_HARBOR_USER}" \
  --password "${PROD_HARBOR_PASSWORD}"
```

### Étape 4 — Remplacer l'image dans le Compose

Créer un fichier `docker-compose.override.yml` à la racine du projet :

```yaml
services:
  whisper:
    image: ${PROD_HARBOR_URL#https://}/${PROD_HARBOR_PROJECT}/whisper-server-vulkan:<VERSION>
```

Remplacer `<VERSION>` par la version cible (ex. `1.3.0`). Les versions disponibles sont listées dans le registre Harbor.

### Étape 5 — Démarrer

```bash
docker compose up -d
```

Docker Compose fusionne automatiquement `docker-compose.yml` et `docker-compose.override.yml`. L'image provient alors de Harbor plutôt que de `ghcr.io`.

### Étape 6 — Vérifier que Vulkan est actif

```bash
docker compose logs whisper | grep -i vulkan
```

### Étape 7 — Tester

```bash
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

### Authentification Harbor échoue

Vérifier que les variables dans `.env` sont correctement renseignées et que votre compte a les droits `pull` sur le projet Harbor.
