# Changelog

## [1.5.1] - 2026-05-17

### Sécurité
- Rebuild de l'image `frontend` sur `nginx:alpine` + `apk upgrade` — corrige 7 CVEs Moyennes dans `curl`/`libcurl` (CVE-2025-14017, CVE-2025-14524, CVE-2025-14819, CVE-2026-1965, CVE-2026-3783, CVE-2026-3784, CVE-2026-3805). Fix : `8.17.0-r1` → `8.19.0-r0`.

---

## [1.5.0] - 2026-05-17

### Ajouté
- Sélecteur de niveau de raisonnement (thinking) dans l'interface web — cinq niveaux : Désactivé, Faible, Moyen, Élevé, Maximum ; défaut : Faible (`low`)
- Paramètre `think` transmis à l'API Ollama (`/api/generate`) à chaque génération de rapport
- Libellés bilingues FR/EN pour le nouveau contrôle

> Modèles compatibles testés : `qwen3.6:27b`, `gpt-oss:120b` (capacité `thinking` confirmée).

---

## [1.4.0] - 2026-05-15

### Ajouté
- Affichage de l'URL Ollama dans l'interface web — visible dans le sous-titre et dans le label du sélecteur de modèles (ex. `Modèles Ollama (depuis http://evo-x2:11434)`)
- Image Docker `frontend` publiée dans Harbor (test + prod) — installation Harbor désormais autonome, sans git clone
- `push-test.sh` / `push-prod.sh` — publient désormais les deux images (`whisper` + `frontend`)
- Runbook install FR + EN restructuré en deux voies : **A** (git clone, source publique) et **B** (Harbor, registre privé, sans git clone)
- ADR-004 (FR + EN) : décision container frontend séparé (nginx)

### Modifié
- `README.md` / `README_EN.md` — section Architecture (deux containers), recommandations de modèles Ollama : `gpt-oss:20b`, `gpt-oss:120b`, `qwen3.6:27b`
- `frontend/config.json` — `ollamaHost` pointé sur `http://evo-x2:11434`
- `ROADMAP.md` — correction typographique `gpt-oos` → `gpt-oss`

### Sécurité
- Rebuild de l'image `frontend` sur `nginx:alpine` mis à jour — corrige CVE-2026-27135 (nghttp2-libs, Haut), CVE-2026-4367 (libxpm, Moyen), CVE-2026-34743 (xz-libs, Moyen). Validé via scan Harbor local avant push test/prod.

---

## [1.3.0] - 2026-05-07

### Ajouté
- Intégration LLM via Ollama — génération de compte rendu en streaming directement depuis l'interface web
- Sélecteur de type de rapport : Résumé, Compte rendu, Procès-verbal, Libre (prompt éditable, mémorisé dans `localStorage`)
- Prompts bilingues FR/EN dans `frontend/prompts.json` — changent automatiquement avec la langue de l'interface
- Sélecteur de modèle Ollama — liste chargée dynamiquement depuis l'API Ollama
- `frontend/config.json` — URL Ollama configurable (cible n'importe quelle machine du réseau)
- Téléchargement du compte rendu en `.md` avec suffixe selon le type (-resume, -pv, -compte-rendu, -free)
- Header `Cache-Control: no-store` sur HTML et JSON — plus besoin de hard refresh après mise à jour

### Modifié
- `frontend/nginx.conf` — ajout de la règle de cache
- `README.md` / `README_EN.md` — documentation de l'interface web intégrée : transcription, génération de compte rendu via Ollama, types de rapport, streaming, téléchargement `.md`
- `README.md` / `README_EN.md` — arborescence mise à jour avec le dossier `frontend/`

---

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
