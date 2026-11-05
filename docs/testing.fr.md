# Tester les contrats React, Tauri IPC et Rust

[English](testing.md) · [Retour à l'accueil](../README.fr.md)

Les tests Rust, TypeScript et WebView ne démontrent pas les mêmes propriétés. Il faut conserver leurs résultats séparément et éviter de déduire une validation de bout en bout à partir des seuls tests unitaires.

## 1. Séparer les responsabilités

Une architecture testable distingue :

- **React :** interface et actions utilisateur.
- **Client TypeScript :** invocation IPC et validation des réponses.
- **Commandes Tauri :** frontière de communication.
- **Domaine Rust :** règles métier et validation des transitions.
- **Fixtures :** données contrôlées utilisées pendant les tests.

Cette séparation permet de tester le domaine indépendamment de la fenêtre graphique.

## 2. Valider les contrats IPC

Les commandes Tauri peuvent être appelées avec `@tauri-apps/api/core`.

Les noms des arguments JavaScript utilisent normalement camelCase. La sérialisation Rust, les attributs Serde et le contrat TypeScript doivent produire les mêmes représentations JSON.

Prévoir des tests pour les champs manquants et inconnus, les versions incompatibles, les valeurs nulles invalides, les discriminants inattendus et les erreurs de transport.

**Les types TypeScript ne remplacent pas une validation JSON à l'exécution.**

## 3. Utiliser des fixtures déterministes

Employer des données fixes et une horloge injectée pour vérifier les décisions et les horodatages.

Comparer les fixtures avant et après les opérations, notamment lorsqu'une transition est refusée.

Ne pas permettre à une requête d'indiquer librement un chemin de fichier à ouvrir.

## 4. Tester les répétitions et la concurrence

Contrôler séparément :

- le rejeu identique d'une demande ;
- la réutilisation d'un identifiant avec un contenu différent ;
- les demandes concurrentes ;
- l'attente bornée et les délais dépassés ;
- l'échec de l'enregistrement d'une preuve ;
- les résultats incertains après une panne injectée.

Une preuve conservée uniquement en mémoire ne garantit pas une reprise après redémarrage.

## 5. Qualifier les preuves

| Contrôle | Ce qu'il démontre | Ce qu'il ne démontre pas |
|---|---|---|
| Tests Rust | Comportement du domaine testé | Invocation réelle depuis React |
| Tests TypeScript | Validation et traitement côté client | Fonctionnement graphique |
| JSON Rust/TypeScript | Compatibilité des objets testés | Transport IPC complet |
| Build natif | Compilation | Affichage correct |
| Observation graphique | Résultat visible | Trace interne intégrale |
| Isolation d'un processus | Comportement du processus testé | Isolation de tous les sous-processus |

Une capture d'écran est une preuve utile, mais ne retrace pas l'intégralité d'un appel IPC.

De même, un test seccomp ciblé ne prouve pas que tous les processus GTK/WebKitGTK sont isolés du réseau.

## Limites

Ces méthodes proviennent d'une simulation locale contrôlée. Elles ne certifient pas des déploiements réels ni une application de production.

## Référence officielle

[Tauri — Calling Rust from the Frontend](https://v2.tauri.app/develop/calling-rust/)
