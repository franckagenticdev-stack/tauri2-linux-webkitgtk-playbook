# Prérequis et préparation Linux (Tauri 2)

[English](installation.md) · [Retour à l'accueil](../README.fr.md)

Cette procédure concerne principalement les distributions desktop Debian/Ubuntu. Ne présumez jamais que les paquets ou versions sont identiques sur toutes les machines.

## 1. Examiner l'environnement (lecture seule)

```bash
cat /etc/os-release
uname -m
node --version
npm --version
rustc --version
cargo --version
pkg-config --modversion webkit2gtk-4.1
```

Documentez les commandes manquantes, le type de montage du workspace et les permissions avant toute installation.

## 2. Vérifier les dépendances Linux

Les [prérequis officiels Tauri 2](https://v2.tauri.app/fr/start/prerequisites/) indiquent pour Debian/Ubuntu : `libwebkit2gtk-4.1-dev`, `build-essential`, `curl`, `wget`, `file`, `libxdo-dev`, `libssl-dev`, `libayatana-appindicator3-dev` et `librsvg2-dev`.

Simulez d'abord l'opération, en vérifiant que les paquets sont disponibles pour votre distribution :

```bash
apt-get -s install libwebkit2gtk-4.1-dev build-essential curl wget file   libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev
```

Aucune installation via `sudo` ne doit être lancée sans votre propre revue et autorisation. Ce dépôt ne déclenche aucune modification système.

## 3. Rust et JavaScript

Vérifiez Rust, Cargo, Node.js et npm. Pour isoler une toolchain, configurez `RUSTUP_HOME` et `CARGO_HOME` dans des dossiers que vous maîtrisez ; vérifiez le PATH et les caches. Consultez les procédures officielles avant de télécharger des installateurs.

## 4. Vérifier l'application avant son lancement graphique

- Contrôlez la CLI Tauri, les scripts du projet et `src-tauri/tauri.conf.json`.
- Vérifiez les ressources nécessaires (dont l'icône `src-tauri/icons/icon.png` si elle est utilisée).
- Exécutez `cargo check` dans l'environnement adapté.
- Construisez un **binaire autonome** avec `tauri build --debug --no-bundle` (commande à adapter à l'outil du projet).
- Arrêtez Vite avant de tester le binaire présenté comme autonome.
- Prévoyez le cache XDG dédié et documentez le code de sortie à la fermeture.

Si `tauri dev` réécrit la même sortie debug, **reconstruisez l'autonome après la dernière session dev**.
