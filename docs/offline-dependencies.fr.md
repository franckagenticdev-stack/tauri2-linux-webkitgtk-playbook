# npm et Cargo lorsque le réseau est indisponible

[English](offline-dependencies.md) · [Retour à l'accueil](../README.fr.md)

Un environnement de développement isolé peut échouer à résoudre les registres de dépendances alors que le terminal Linux habituel dispose d'un accès Internet fonctionnel.

## 1. Identifier la panne

Comparer les résultats de ces commandes dans les deux environnements :

```bash
getent ahosts registry.npmjs.org
getent ahosts static.rust-lang.org

curl -I --connect-timeout 5 --max-time 10 \
  https://registry.npmjs.org/
```

Dans un cas de développement documenté, la résolution échouait dans l'environnement isolé mais réussissait sur le système hôte.

Ce constat ne justifie pas de modifier immédiatement les DNS de Linux ni de désactiver TLS.

## 2. Vérifier une archive npm

Récupérer l'archive de la version souhaitée depuis une source fiable, dans un environnement autorisé à accéder au réseau.

Calculer ses empreintes :

```bash
sha256sum /chemin/vers/paquet.tgz
sha512sum /chemin/vers/paquet.tgz
```

Comparer ces empreintes à une référence indépendante lorsqu'elle existe, notamment à l'intégrité publiée par le registre.

Une empreinte calculée localement ne prouve pas, à elle seule, l'origine ni la sûreté du fichier.

## 3. Installation npm hors ligne

Après contrôle du paquet et du lockfile, une procédure possible est :

```bash
npm cache add --offline --ignore-scripts \
  /chemin/vers/paquet-verifie.tgz

npm ci --offline --ignore-scripts \
  --no-audit --no-fund
```

**Conditions indispensables :** disposer d'un `package-lock.json` compatible et d'un cache contenant l'ensemble des dépendances et métadonnées nécessaires.

Charger une archive ne suffit pas nécessairement à rendre toute l'installation autonome.

L'option `--ignore-scripts` empêche les scripts de cycle de vie durant l'installation. Certains paquets peuvent nécessiter des opérations complémentaires, à examiner avant exécution.

## 4. Résolution Cargo sans réseau

Avec les crates nécessaires déjà disponibles localement :

```bash
cargo metadata --offline --locked \
  --format-version 1 \
  --manifest-path src-tauri/Cargo.toml
```

`--offline` interdit les accès réseau de Cargo ; `--locked` exige la cohérence avec `Cargo.lock`.

Le succès de cette commande prouve une résolution de dépendances dans le contexte testé, pas la compilation ni le fonctionnement de l'application.

## 5. Conserver les preuves

Noter les versions, commandes, codes de retour, résultats attendus, résultats obtenus et éventuelles dépendances manquantes.

Éviter la suppression globale des caches et les modifications réseau non justifiées.

## Limites

Cette approche a permis de débloquer un environnement Linux/Tauri particulier. Elle doit être adaptée et revalidée sur chaque projet.

## Documentation officielle

- [npm cache](https://docs.npmjs.com/cli/cache/)
- [npm ci](https://docs.npmjs.com/cli/commands/npm-ci/)
- [Cargo metadata](https://doc.rust-lang.org/cargo/commands/cargo-metadata.html)
