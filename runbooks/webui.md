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

## Génération de compte rendu (Ollama)

Après transcription, le texte peut être soumis à Ollama — qui tourne localement sur la même machine Strix Halo, accéléré par le GPU AMD — pour produire un document structuré.

1. Sélectionner le type de rapport dans la liste déroulante
2. Choisir le modèle Ollama
3. Choisir le niveau de raisonnement
4. Cliquer **Générer**
5. La réponse s'affiche en streaming temps réel
6. Copier le résultat ou le télécharger en `.md`

![Sélection du type de rapport](../docs/images/ReportType.png)

Types disponibles :

- **Résumé** — version courte avec points clés, décisions et actions
- **Compte rendu** — synthèse structurée par sujet
- **Procès-verbal** — retranscription fidèle et exhaustive
- **Libre** — prompt personnalisé

Modèles ayant donné de bons résultats : `gpt-oss:20b`, `gpt-oss:120b`, `qwen3.6:27b`.

### Niveau de raisonnement (Thinking)

Le sélecteur **Raisonnement** contrôle l'effort de réflexion du modèle avant de produire sa réponse. Cinq niveaux disponibles :

| Niveau | Usage conseillé |
|---|---|
| Désactivé | Réponse directe, sans réflexion préalable |
| Faible *(défaut)* | Résumés et rapports courants |
| Moyen | Rapports plus complexes, ambiguïtés dans la transcription |
| Élevé | Procès-verbaux, synthèses longues |
| Maximum | Analyses approfondies, réunions très denses |

Plus le niveau est élevé, plus la génération est lente. Le thinking n'a d'effet que sur les modèles qui supportent cette capacité — testé : `qwen3.6:27b`, `gpt-oss:120b`.

## Confidentialité

Le fichier audio est traité en mémoire dans le container whisper. Aucune trace ne reste côté serveur après la transcription — ni le fichier audio, ni le texte. La génération de compte rendu via Ollama est également locale : aucune donnée ne quitte la machine.

## Connexion Ollama et CORS

### Pourquoi le navigateur ne peut pas contacter Ollama directement

La liste des modèles et la génération de rapport s'exécutent en JavaScript **dans le navigateur** — ce n'est pas le serveur nginx qui appelle Ollama, c'est le browser. Le navigateur joint Ollama à l'URL définie dans `frontend/config.json`.

Quand le browser fait un appel vers un port différent (ex. `8765` → `11434`), c'est une requête **cross-origin**. Le navigateur envoie un en-tête `Origin` contenant l'URL de la barre d'adresse. Ollama vérifie si cette origine est autorisée avant de répondre.

Exemple : pour un accès à `http://evo-x2:8765`, le browser envoie `Origin: http://evo-x2:8765` à Ollama sur le port `11434`. Si cette origine n'est pas dans la liste d'Ollama → requête bloquée, modèles invisibles.

### Variable OLLAMA_ORIGINS

Sur le container Ollama, définir la variable d'environnement :

```
OLLAMA_ORIGINS=http://evo-x2:8765
```

Plusieurs origines séparées par des virgules :

```
OLLAMA_ORIGINS=http://evo-x2:8765,http://ma-machine-locale:8765
```

Wildcard (toutes origines autorisées) :

```
OLLAMA_ORIGINS=*
```

### Risques selon la valeur

| Valeur | Sécurité | Usage recommandé |
|---|---|---|
| `http://evo-x2:8765` | Élevée — seul ce frontend est autorisé | Serveur exposé sur internet |
| `http://evo-x2:8765,http://autre:8765` | Élevée — liste explicite | Plusieurs frontends connus |
| `*` | Faible — n'importe quelle page web peut appeler Ollama | Réseau local privé uniquement |

> **Note :** l'IP du container Docker (`172.17.x.x`) ne sert à rien ici — elle n'apparaît jamais dans la barre d'adresse du navigateur, donc jamais dans l'en-tête `Origin`.

### Vérifier dans la console navigateur

Si les modèles n'apparaissent pas, ouvrir la console (F12) : une erreur `blocked by CORS policy` confirme que `OLLAMA_ORIGINS` est absent ou ne contient pas l'origine courante.

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
