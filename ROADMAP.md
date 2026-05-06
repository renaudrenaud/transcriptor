# Roadmap

## Étape 1 — Frontend web

Interface de transcription partagée, accessible depuis n'importe quelle machine du parc Strix Halo.

### Contexte

- Usage interne uniquement (réseau local, parc Strix Halo)
- Accès libre, pas d'authentification
- Session jetable — pas d'historique persisté
- Stack : page statique HTML/CSS/JS vanilla (pas de build, pas de framework)

### Architecture Docker

Deux containers dans `docker-compose.yml` :

- `whisper` — inchangé, port 8080 **non exposé** à l'extérieur
- `frontend` — nginx, port 80, sert les fichiers statiques + reverse proxy

```
                  réseau interne Docker
[navigateur] → frontend:80 → /api/* → whisper:8080
```

### Structure

```
transcriptor/
├── docker-compose.yml       ← ajoute le service frontend
└── frontend/
    ├── index.html
    └── nginx.conf           ← proxy /api → whisper:8080
                             ← proxy /api/summarize → llm:* (étape 2)
```

### Fonctionnalités

- Drag & drop ou sélecteur de fichier audio
- Sélecteur de langue (défaut : `fr`)
- Appel `POST /api/v1/audio/transcriptions` avec indicateur de progression
- Affichage du texte résultant
- Téléchargement en `.txt`

---

## Étape 2 — Intégration LLM (compte rendu)

À partir du texte transcrit, appel à un LLM local pour générer un compte rendu structuré.

### Principe

```
Transcription  →  LLM  →  Compte rendu
  meeting.txt            compte_rendu.md
```

- Endpoint `/api/summarize` ajouté dans nginx (proxy vers le service LLM)
- Le frontend proposera un bouton "Générer le compte rendu" après transcription
- Format de sortie : Markdown téléchargeable

> Hors scope pour l'instant — à affiner lors de l'étape 1.
