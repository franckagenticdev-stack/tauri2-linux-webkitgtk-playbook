# Contournement : cache `XDG_CACHE_HOME` isolé pour Tauri 2 / WebKitGTK

[English](xdg-cache-workaround.md) · [Retour à l'accueil](../README.fr.md)

> **Résultat observé (novembre 2026) :** une fenêtre native Tauri 2 blanche s'est correctement affichée avec un répertoire `XDG_CACHE_HOME` temporaire vide. Un cache permanent dédié à l'application a ensuite fonctionné. Il s'agit d'un **contournement expérimental**, pas d'une correction démontrée du défaut WebKitGTK.

## Pourquoi isoler et non supprimer ?

Changer uniquement la racine du cache de l'application permet de comparer les résultats sans toucher au `~/.cache` habituel. **Cela n'isole pas le programme du système de fichiers ou du réseau** : ce n'est pas une sandbox.

## Expérience minimale

```bash
BIN="/chemin/absolu/vers/un/binaire/tauri/de/confiance"
test -x "$BIN" || exit 1
TEMP_CACHE="$(mktemp -d /tmp/tauri-xdg.XXXXXX)" || exit 1
printf 'Cache temporaire : %s
' "$TEMP_CACHE"
env XDG_CACHE_HOME="$TEMP_CACHE" "$BIN"
printf 'APP_EXIT=%s
' "$?"
```

Vérifier que les autres paramètres sont identiques avant et après l'essai. Conserver le résultat exact, sans généralisation abusive.

## Lanceur permanent

Voir [l'exemple Bash](../examples/launch-with-isolated-xdg-cache.sh). Il exige un chemin absolu vers un exécutable connu et un identifiant d'application unique. Il refuse root, les répertoires de cache symboliques ou non conformes et ne crée qu'un répertoire propre à l'application sous `$HOME/.cache`.

Exemple **après relecture et adaptation** :

```bash
bash examples/launch-with-isolated-xdg-cache.sh /chemin/absolu/vers/app mon-application
```

Sur certains montages, les permissions affichées peuvent différer des permissions demandées ; le lanceur refuse la poursuite si son contrôle échoue, sans toucher aux autres caches.

## Précautions

- Ne jamais effacer ou modifier globalement `~/.cache` ou Fontconfig.
- Ne pas lancer avec `sudo` ; ne pas utiliser un exécutable non fiable.
- Cache séparé ≠ sandbox, ni garantie de correction universelle.
- Documenter OS, X11/Wayland, versions, commandes, affichage et code de sortie.
