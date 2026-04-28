# Runbook — Transcription

## Prérequis

Le serveur whisper doit tourner :

```bash
docker compose up -d
```

## Transcrire un fichier

```bash
./transcribe.sh ~/Téléchargements/meeting.mp3
```

Le résultat est généré dans `~/Téléchargements/transcription/meeting.txt`.

## Options

**Changer la langue** (défaut : `fr`) :

```bash
./transcribe.sh ~/Téléchargements/meeting.mp3 en
```

**Appel direct à l'API** :

```bash
curl http://127.0.0.1:8080/v1/audio/transcriptions \
  -F "file=@meeting.mp3" \
  -F "model=whisper-1" \
  -F "language=fr" \
  -F "response_format=text"
```

Formats de réponse disponibles : `text`, `json`, `verbose_json`, `srt`, `vtt`.

## Dépannage

### Erreur de connexion

Vérifier que le serveur tourne :

```bash
docker compose ps
docker compose logs whisper
```

### Transcription vide ou incohérente

- Vérifier la qualité audio du fichier source (pas trop de bruit, niveau correct)
- Vérifier que la langue spécifiée correspond bien à celle de l'audio
