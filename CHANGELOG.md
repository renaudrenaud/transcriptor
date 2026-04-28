# Changelog

## [1.0.0] - 2026-04-28

### Ajouté
- Transcription audio locale via `ghcr.io/kth8/whisper-server-vulkan` (whisper.cpp + Vulkan)
- Accélération GPU AMD via passthrough `/dev/kfd` + `/dev/dri`
- Script `transcribe.sh` — wrapper CLI vers l'API HTTP
- `docker-compose.yml` — démarrage du serveur en une commande
- Runbooks : installation, enregistrement, transcription
- ADRs : choix de whisper.cpp, backend Vulkan, image pré-compilée
