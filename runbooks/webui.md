# Runbook — Interface web

Interface de transcription accessible depuis le navigateur, partagée sur le réseau local.

## Prérequis

Le serveur whisper et le frontend doivent tourner :

```bash
docker compose up -d
```

## Accès

Ouvrir dans le navigateur depuis n'importe quelle machine du réseau local :

```
http://<ip-de-la-machine>:8765
```

Depuis la machine hôte :

```
http://localhost:8765
```

## Utilisation

1. Glisser-déposer un fichier audio (ou cliquer pour parcourir)
2. Sélectionner la langue (défaut : `fr`)
3. Cliquer **Transcrire**
4. Patienter — environ 2 minutes pour 1h d'audio
5. Copier le texte ou télécharger en `.txt`

## Confidentialité

Le fichier audio est traité en mémoire dans le container whisper. Aucune trace ne reste côté serveur après la transcription — ni le fichier audio, ni le texte.

## Dépannage

### Page inaccessible

```bash
docker compose ps
# Les deux containers doivent être "Up" : whisper et frontend
```

### Erreur 504 Gateway Time-out

Le fichier audio est trop long pour le timeout configuré (600s). Vérifier la durée du fichier — au-delà de ~4 heures d'audio, augmenter `proxy_read_timeout` dans `frontend/nginx.conf`.

### Trouver l'IP de la machine hôte

```bash
ip route get 1 | awk '{print $7; exit}'
```
