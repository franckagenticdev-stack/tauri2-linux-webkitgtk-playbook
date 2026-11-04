# Tauri 2 sous Linux — Guide de dépannage WebKitGTK

[English version](README.md) · [Installation](docs/installation.fr.md) · [Diagnostic](docs/troubleshooting.fr.md) · [Cache XDG isolé](docs/xdg-cache-workaround.fr.md)

Guide de diagnostic reproductible pour **Tauri 2 + Rust + React / TypeScript + Vite** sous Linux, centré sur les **fenêtres blanches WebKitGTK**, les ressources frontend et l'isolation du cache local.

> **Solution observée, pas correction universelle.** Un cache XDG séparé a rétabli l'affichage dans **un environnement de développement Zorin OS 18.1 / base Ubuntu 24.04** en novembre 2026. La cause exacte n'a pas été prouvée : la méthode doit être testée et documentée sur chaque machine.

## Résumé des diagnostics

| Symptôme | Vérification prioritaire | Observation dans l'étude de cas |
| --- | --- | --- |
| Échec de `cargo check` sur une ressource d'icône | `src-tauri/icons/icon.png` existe-t-il et est-il valide ? | L'icône absente bloquait la compilation ; sa création a débloqué le contrôle. |
| Fenêtre blanche Tauri, mais application visible dans le navigateur | Tester un cache `XDG_CACHE_HOME` temporaire neuf | L'affichage est revenu ; un cache permanent dédié a ensuite fonctionné. |
| Connexion refusée à `127.0.0.1:5173` | Le binaire provenait-il du dernier `tauri dev` ? | La reconstruction autonome a supprimé la dépendance au serveur Vite. |
| Processus WebKit très consommateur de CPU | Comparer les processus et l'essai avec cache séparé | Symptôme observé, cause Fontconfig/WebKitGTK non démontrée. |

## Démarrage

1. Consulter [les prérequis Linux](docs/installation.fr.md) et examiner les outils déjà installés.
2. Suivre [le diagnostic](docs/troubleshooting.fr.md), en conservant les journaux et résultats.
3. Tester [le cache XDG isolé](docs/xdg-cache-workaround.fr.md) sans effacer les caches habituels.
4. Adapter le [lanceur d'exemple](examples/launch-with-isolated-xdg-cache.sh) à votre application.
5. Ouvrir une [Issue](https://github.com/franckagenticdev-stack/tauri2-linux-webkitgtk-playbook/issues/new/choose) si le défaut persiste ou pour confirmer une amélioration, sans y inclure de données privées.

## Environnement observé (et non exigence minimale)

- Zorin OS 18.1, base Ubuntu 24.04 (`noble`).
- Tauri CLI 2.12.4, Rust/Cargo 1.99.1, Vite 6.4.4, React/TypeScript.
- Build natif `tauri build --debug --no-bundle` réussi, affichage restauré, fermeture normale (`exit 0`).
- Aucune conclusion définitive sur la cause racine du dysfonctionnement initial.

## Suivi communautaire

GitHub permet de marquer le projet avec une **Star**, d'activer **Watch**, de signaler les erreurs dans **Issues**, de proposer des changements via **Pull Requests** et de discuter dans **Discussions** si le propriétaire active cette fonction. Les indicateurs d'activité sont accessibles selon les fonctions proposées par GitHub.

## Sécurité et conditions de réutilisation

La documentation n'exécute aucune installation ni opération privilégiée. Relisez toujours les scripts, chemins, versions et permissions. Ne supprimez pas le cache habituel de votre système.

**Licence :** ce dépôt est publié sous [licence MIT](LICENSE), copyright © 2026 franckagenticdev-stack. La solution est fournie **en l'état**, sans garantie de fonctionner dans tous les environnements.
