# Dépannage des fenêtres blanches Tauri 2 sous Linux

[English](troubleshooting.md) · [Retour à l'accueil](../README.fr.md)

**Symptômes observés dans un cas de développement** : React/Vite fonctionnait dans un navigateur normal mais la fenêtre native Tauri/WebKitGTK restait blanche ; un processus WebKit consommait beaucoup de CPU. Cela ne démontre pas une cause précise.

## Parcours de diagnostic avec preuves

1. Vérifier l'affichage du **frontend dans le navigateur** et noter l'URL et la console.
2. Vérifier `dist/index.html`, les ressources CSS/JS, `frontendDist`, `devUrl` et la CSP Tauri.
3. Distinguer **`tauri dev`** (serveur de développement requis) de **`tauri build --debug --no-bundle`** (binaire autonome).
4. Si la fenêtre native reste blanche, lancer un test avec un **cache XDG temporaire neuf**, sans toucher au cache usuel.
5. Si ce test fonctionne, utiliser un répertoire de cache permanent propre à l'application, puis vérifier affichage et code de sortie.
6. Noter OS, système de fenêtres, versions GTK/WebKitGTK/Tauri, logs, utilisation CPU, variables d'environnement et résultats.

## Test temporaire contrôlé

```bash
# Remplacer par un chemin vers VOTRE exécutable approuvé.
BIN="/chemin/absolu/vers/votre/application"
test -x "$BIN" || { echo 'Binaire invalide'; exit 1; }
TEST_CACHE="$(mktemp -d /tmp/tauri2-xdg-test.XXXXXX)" || exit 1
printf 'Cache temporaire : %s
' "$TEST_CACHE"
env XDG_CACHE_HOME="$TEST_CACHE" "$BIN"
# Examiner le répertoire avant un nettoyage manuel éventuel.
```

Aucun cache global n'est modifié par ce test. Le binaire lancé peut effectuer ses propres opérations, indépendantes de cette procédure.

## Erreur `127.0.0.1:5173`

Si `tauri dev` a remplacé le binaire debug autonome, ce dernier peut demander un serveur Vite absent. Après la dernière session dev, reconstruire avec `tauri build --debug --no-bundle`, puis tester avec Vite arrêté. Un `vite build` réussi ne prouve pas à lui seul l'autonomie de l'exécutable natif.

## Limites

Le cache isolé a résolu le problème d'affichage sur la machine étudiée. **La cause profonde n'est pas établie**, y compris le rôle éventuel de Fontconfig. Les autres résultats sont bienvenus dans Issues.
