# Changelog

## [Unreleased]

### Ajouté
- `README_EN.md` — version anglaise du README
- `runbooks_en/` — traduction anglaise des trois runbooks (install, recording, transcription)
- `adr_en/` — traduction anglaise des ADRs
- `ROADMAP.md` — frontend web envisagé
- `SECURITY.md` — état des CVEs du scan Harbor et décision de ne pas patcher (service local, sévérité Medium/Low uniquement)

---

## [1.0.0] - 2026-04-28

### Ajouté
- Transcription audio locale via `ghcr.io/kth8/whisper-server-vulkan` (whisper.cpp + Vulkan)
- Accélération GPU AMD via passthrough `/dev/kfd` + `/dev/dri`
- Script `transcribe.sh` — wrapper CLI vers l'API HTTP
- `docker-compose.yml` — démarrage du serveur en une commande
- Runbooks : installation, enregistrement, transcription
- ADRs : choix de whisper.cpp, backend Vulkan, image pré-compilée
