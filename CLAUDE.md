# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projet

Transcription audio locale via whisper.cpp avec accélération GPU AMD (Vulkan). Utilise l'image pré-compilée `ghcr.io/kth8/whisper-server-vulkan` — pas de build from source.

## Commandes principales

```bash
# Démarrer le serveur whisper
docker compose up -d

# Transcrire un fichier audio (script helper)
./transcribe.sh ~/Téléchargements/meeting.mp3

# Voir les logs (vérifier que Vulkan est actif)
docker compose logs whisper

# Arrêter
docker compose down
```

## Architecture

- **`docker-compose.yml`** : lance l'image pré-compilée, mappe `/dev/kfd` + `/dev/dri` pour le GPU AMD, expose le port 8080.
- **`transcribe.sh`** : wrapper curl vers l'API HTTP `POST /v1/audio/transcriptions` (compatible OpenAI Whisper API). Génère le `.txt` dans un sous-dossier `transcription/` à côté du fichier source.
- Pas de Dockerfile — le build from source a été abandonné (connexion GitHub bloquée depuis la Chine sans VPN container, voir ADR-005).

## Décisions d'architecture

Les ADRs dans `adr/` documentent les choix structurants :
- `001` — Choix de whisper.cpp
- `002` — Backend Vulkan (GPU AMD)
- `003` — Image pré-compilée (approche actuelle)

## Runbooks

`runbooks/install.md` couvre : prérequis Vulkan/kfd, pull de l'image, démarrage, vérification GPU, dépannage.
