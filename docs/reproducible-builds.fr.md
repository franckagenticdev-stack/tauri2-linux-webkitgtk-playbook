# Dépendances reproductibles et builds Tauri autonomes

[English](reproducible-builds.md) · [Retour à l'accueil](../README.fr.md)

Une compilation réussie ne suffit pas pour comprendre exactement les changements effectués. Il est utile de préserver l'état précédent, puis de comparer les fichiers de dépendances avant et après intervention.

## 1. Enregistrer l'état BEFORE

Dans un projet npm/Rust/Tauri, identifier notamment :

- `package.json`
- `package-lock.json`
- `src-tauri/Cargo.toml`
- `src-tauri/Cargo.lock`

Si ces fichiers existent, relever leurs empreintes :

```bash
sha256sum package.json package-lock.json \
  src-tauri/Cargo.toml src-tauri/Cargo.lock
```

Conserver une sauvegarde distincte, contrôlée et non écrasée, avant toute modification autorisée.

## 2. Maîtriser les versions

Pour npm, utiliser un lockfile vérifié et privilégier `npm ci` lorsque le projet s'y prête.

Pour Cargo, `--locked` impose la cohérence du lockfile. Ajouter `--offline` lorsque les dépendances nécessaires sont déjà présentes localement.

Un cache incomplet peut empêcher une opération hors ligne, même avec un lockfile correct.

## 3. Comparer l'état AFTER

Dans un dépôt Git existant :

```bash
git diff -- package.json package-lock.json \
  src-tauri/Cargo.toml src-tauri/Cargo.lock
```

Contrôler également les nouvelles empreintes SHA-256.

Rechercher les mises à niveau inattendues, les modifications de provenance ou d'intégrité et les dépendances ajoutées hors périmètre.

## 4. Distinguer développement et binaire autonome

`tauri dev` peut s'appuyer sur un serveur frontend Vite.

Un binaire construit pour fonctionner de manière autonome doit être testé **avec Vite arrêté**.

Dans un cas Linux documenté, une session `tauri dev` avait remplacé le binaire debug précédemment autonome. Une reconstruction avec `tauri build --debug --no-bundle` a rétabli son comportement autonome.

Cela ne signifie pas que toutes les configurations Tauri utilisent les mêmes chemins ou présentent le même comportement.

Vérifier la commande de construction, le lancement de la fenêtre, le rendu et la fermeture.

Voir aussi [l'installation](installation.fr.md) et [le diagnostic](troubleshooting.fr.md).

## 5. Préparer le retour arrière

Comparer l'état courant aux empreintes AFTER attendues avant toute restauration.

Si les fichiers ont changé depuis la sauvegarde, interrompre l'opération et analyser les différences. Ne jamais écraser automatiquement un travail ultérieur.

## Limites

Les empreintes prouvent l'identité des fichiers comparés. Une compilation réussie ne certifie ni la sécurité, ni le rendu graphique, ni l'aptitude à la production.

## Références

- [npm ci](https://docs.npmjs.com/cli/commands/npm-ci/)
- [Cargo check](https://doc.rust-lang.org/cargo/commands/cargo-check.html)
- [CLI Tauri](https://v2.tauri.app/reference/cli/)
