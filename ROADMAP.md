# Roadmap

## Frontend web

Interface de transcription accessible depuis le navigateur.

### Architecture

- Deux containers séparés dans `docker-compose.yml` : `whisper` (existant, inchangé) + `frontend` (nginx)
- Le front appelle whisper via le réseau interne Docker (`http://whisper:8080`) — le port whisper n'est pas exposé à l'extérieur
- nginx sert la page statique et fait reverse proxy `/api` → `whisper:8080`

### Structure envisagée

```
transcriptor/
├── docker-compose.yml       ← ajoute le service frontend
└── frontend/
    ├── index.html
    └── nginx.conf
```

### Fonctionnalités

- Drag & drop d'un fichier audio
- Choix de la langue
- Appel `POST /v1/audio/transcriptions`
- Affichage et copie du texte résultant
