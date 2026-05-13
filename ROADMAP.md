# Roadmap

## ✅ Étape 1 — Frontend web (livré en v1.2.0)

Interface de transcription partagée, accessible depuis n'importe quelle machine du parc Strix Halo.

- Page statique HTML/CSS/JS vanilla, servie par nginx sur le port **8765**
- Drag & drop MP3, sélecteur de langue audio, téléchargement `.txt`
- Interface bilingue FR/EN, choix mémorisé dans `localStorage`
- Port whisper non exposé à l'extérieur — tout passe par nginx

```
[navigateur]:8765 → frontend (nginx) → /api/* → whisper:8080
```

---

## ✅ Étape 2 — Intégration LLM (compte rendu, livré en v1.3.0)

À partir du texte transcrit, appel à Ollama pour générer un compte rendu structuré.

### Contexte

- Ollama tourne sur le host (`http://localhost:11434`) — pas dans Docker
- Modèle : `gpt-oss:20b`
- Depuis les containers Docker, Ollama est accessible via `host.docker.internal:11434`

### Principe

```
Transcription  →  Ollama (gpt-oos:20b)  →  Compte rendu
  meeting.txt                                compte_rendu.md
```

### Architecture envisagée

- Endpoint `/api/llm/` ajouté dans `nginx.conf` — proxy vers `host.docker.internal:11434`
- Bouton "Générer le compte rendu" affiché dans le frontend après transcription
- Appel `POST /api/llm/api/generate` avec le texte transcrit comme prompt
- Format de sortie : Markdown téléchargeable en `.md`

### Points à trancher

- Prompt système à définir (structure du compte rendu, langue de sortie)
- Faut-il proposer plusieurs templates (compte rendu, liste de décisions, todo…) ?
