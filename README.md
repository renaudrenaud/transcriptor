# transcriptor

[English version](README_EN.md)

Transformez vos enregistrements audio en texte, **localement**, **rapidement**, **en toute confidentialité**.

- Transcriptor exploite la puissance GPU des machines **AMD Strix Halo** (GMKTec EVO2, Asus ROG Flow Z13 2025…) 
- pour transcrire par exemple une heure d'enregistrement audio MP3 en moins de deux minutes 
- sans envoyer une seule donnée dans le cloud !
- Le texte produit peut ensuite être soumis à 
    - une interfce web intégrée qui appelle Ollama (local ou distant) pour la génératin du compte rendu en toute confidentialié. 
    - un LLM externe quelconque via copier-coller, dans ce cas la confidentialité n'est plus garantie ! 

## Pourquoi Transcriptor ?

- **Confidentialité totale** : l'audio ne quitte jamais la machine. Les fichiers sont traités en mémoire dans le container — aucune trace ne reste côté serveur après la transcription. Idéal pour les réunions sensibles.
- **Rapide** : ~2 minutes pour 1 heure d'audio sur les machines Strix Halo de notre parc.
- **Simple** : une commande pour démarrer, une commande pour transcrire.
- **Flexible** : l'API compatible OpenAI Whisper permet l'intégration dans n'importe quel pipeline de traitement.

## Flux de travail typique

```
Enregistrement audio  →  Transcription (Transcriptor)  →  LLM  →  Compte rendu
      meeting.mp3              meeting.txt                          compte_rendu.md
```

![Interface web Transcriptor](docs/images/main.png)

## Interface web intégrée

Transcriptor inclut une interface web accessible sur `http://localhost:8765` qui permet de transcrire et de générer des comptes rendus en quelques clics.

### Transcription

- **Glisser-déposer** de fichiers MP3
- **Choix de la langue** de l'audio (français, anglais, auto-détection)
- **Copier** le texte ou le **télécharger** en `.txt`

### Génération de compte rendu (Ollama)

Après transcription, soumettez le texte à un LLM local via Ollama pour produire automatiquement un document structuré :

- **Résumé** — version courte avec points clés, décisions et actions
- **Compte rendu** — synthèse structurée par sujet
- **Procès-verbal** — retranscription fidèle et exhaustive
- **Libre** — prompt personnalisé

La réponse est affichée en **streaming temps réel** et peut être copiée ou téléchargée en `.md`. L'interface est disponible en **français et en anglais**.

Modèles ayant donné de bons résultats : `gpt-oss:20b`, `gpt-oss:120b`, `qwen3.6:27b`.

## Démarrage rapide

```bash
docker compose up -d
```

- **Interface web** : `http://localhost:8765`
- **CLI** : `./transcribe.sh ~/Téléchargements/meeting.mp3`

Voir les [runbooks](#runbooks) pour l'installation complète et les options avancées.

## Architecture

Transcriptor repose sur **deux containers** :

| Container | Rôle |
|-----------|------|
| `whisper` | Serveur de transcription (whisper.cpp + Vulkan). Expose une API HTTP interne. |
| `frontend` | Nginx : sert l'interface web et proxifie les appels API vers `whisper`. |

Le container `frontend` est optionnel si vous n'utilisez que la CLI (`./transcribe.sh`). Dans ce cas, un seul container suffit :

```bash
docker compose up -d whisper
```

## Performances

Sur les machines équipées d'un **AMD AI 395 (Strix Halo)** — comme le GMKTec EVO2 ou l'Asus ROG Flow Z13 2025 — une heure d'audio MP3 est transcrite en environ **2 minutes**.

## Runbooks

- [Installation](runbooks/install.md) — prérequis, pull de l'image, démarrage, dépannage
- [Interface web](runbooks/webui.md) — accès depuis le réseau local (port 8765), utilisation, dépannage
- [Enregistrement](runbooks/enregistrement.md) — capturer un meeting (micro + interlocuteurs)
- [Transcription](runbooks/transcription.md) — transcrire un fichier audio (CLI)

## Décisions d'architecture

- [ADR-001 — Choix de whisper.cpp](adr/001-whisper-cpp.md)
- [ADR-002 — Backend GPU : Vulkan](adr/002-vulkan-backend.md)
- [ADR-003 — Image pré-compilée au lieu de build from source](adr/003-image-pre-compilee.md)
- [ADR-004 — Container frontend séparé (nginx)](adr/004-frontend-container.md)

## Structure

```
transcriptor/
├── docker-compose.yml
├── transcribe.sh
├── frontend/
│   ├── Dockerfile
│   ├── index.html
│   ├── config.json
│   ├── prompts.json
│   └── nginx.conf
├── adr/
│   ├── 001-whisper-cpp.md
│   ├── 002-vulkan-backend.md
│   ├── 003-image-pre-compilee.md
│   └── 004-frontend-container.md
└── runbooks/
    ├── install.md
    ├── webui.md
    ├── enregistrement.md
    └── transcription.md
```
