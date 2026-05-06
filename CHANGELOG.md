# Changelog

## [1.2.0] - 2026-05-06

### Ajouté
- Interface web bilingue FR/EN — bouton de bascule en haut à droite, choix mémorisé dans `localStorage`

---

## [1.1.0] - 2026-05-06

### Ajouté
- `README_EN.md` — version anglaise du README
- `runbooks_en/` — traduction anglaise des trois runbooks (install, recording, transcription)
- `adr_en/` — traduction anglaise des ADRs
- `ROADMAP.md` — feuille de route (frontend web, intégration LLM)
- `SECURITY.md` — état des CVEs du scan Harbor et décision de ne pas patcher
- `frontend/` — interface web (nginx, port 8765) : drag & drop MP3, sélecteur de langue, téléchargement `.txt`
- Runbooks web UI (FR + EN)

### Modifié
- `docker-compose.yml` — ajout du service `frontend`, port whisper non exposé à l'extérieur
- READMEs — démarrage rapide mis à jour avec l'URL web UI, mention de la confidentialité en mémoire

---

## [1.0.0] - 2026-04-28

### Ajouté
- Transcription audio locale via `ghcr.io/kth8/whisper-server-vulkan` (whisper.cpp + Vulkan)
- Accélération GPU AMD via passthrough `/dev/kfd` + `/dev/dri`
- Script `transcribe.sh` — wrapper CLI vers l'API HTTP
- `docker-compose.yml` — démarrage du serveur en une commande
- Runbooks : installation, enregistrement, transcription
- ADRs : choix de whisper.cpp, backend Vulkan, image pré-compilée
