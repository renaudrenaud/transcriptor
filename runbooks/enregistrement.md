# Runbook — Enregistrement audio d'un meeting

Capture simultanée du son sortant (interlocuteurs) et du micro local via PulseAudio/ffmpeg.

## Prérequis

```bash
sudo apt install ffmpeg pulseaudio-utils
```

## Enregistrer un meeting

```bash
ffmpeg \
  -f pulse -i $(pactl get-default-sink).monitor \
  -f pulse -i $(pactl get-default-source) \
  -filter_complex "[1]volume=3.0[mic];[0][mic]amix=inputs=2" \
  ~/Téléchargements/meeting.mp3
```

- `.monitor` : capture ce qui sort des enceintes/casque (les autres)
- `get-default-source` : micro actif par défaut
- `volume=3.0` : amplifie le micro ×3 (ajuster selon le niveau réel)

Arrêter l'enregistrement : **Ctrl+C** — le fichier est sauvegardé à ce moment.

## Ajuster le niveau du micro

**Option 1 — dans la commande** : modifier `volume=3.0` (essayer 2.0, 4.0…)

**Option 2 — via l'interface** : ouvrir `pavucontrol`, onglet "Input Devices", ajuster le gain en temps réel avant de lancer l'enregistrement.

Vérifier quel micro est sélectionné par défaut :

```bash
pactl get-default-source
```
