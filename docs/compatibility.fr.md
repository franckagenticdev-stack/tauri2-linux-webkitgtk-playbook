# Compatibilité Linux/Tauri et niveaux de preuve

[English](compatibility.md) · [Retour à l'accueil](../README.fr.md)

Ce document présente une configuration Linux/Tauri observée en novembre 2026 et explique comment décrire correctement les résultats des essais.

## Environnement de référence

| Composant | Version observée |
|---|---|
| Distribution | Zorin OS 18.1, base Ubuntu 24.04 |
| Architecture | Linux x86_64 |
| Node.js | 20.20.2 |
| npm | 10.8.2 |
| Rust / Cargo | 1.99.1 |
| CLI Tauri | 2.12.4 |
| API JavaScript Tauri | 2.12.4 |
| Crate Rust Tauri | 2.12.5 |
| WebKitGTK | 2.52.6 |
| GTK | 3.24.41 |
| libsoup | 3.4.4 |

Ces versions correspondent à un cas testé et daté. Elles ne constituent ni des versions minimales obligatoires ni une liste de versions recommandées.

Une différence entre les versions de la CLI, du SDK JavaScript et de la crate Tauri ne suffit pas à conclure à une incompatibilité. Vérifier les dépendances résolues, les exigences officielles et le comportement de l'application.

## Vérifier sa propre machine

```bash
cat /etc/os-release
uname -m
node --version
npm --version
rustc --version
cargo --version
pkg-config --modversion webkit2gtk-4.1
```

Noter les outils absents avant d'envisager une installation.

## Classification des résultats

**PASS observé :** contrôle explicitement réussi dans l'environnement décrit.

**FAIL observé :** échec constaté et consigné.

**Contournement validé localement :** méthode alternative ayant amélioré le résultat, sans démonstration de la cause initiale.

**Vérification partielle :** certaines couches ont été testées mais il manque encore une preuve importante.

**Non testé :** absence de preuve pour le point considéré.

**Hypothèse :** explication possible non démontrée.

## Exemples de formulation

« Un cache XDG isolé a rétabli le rendu sur la machine testée » décrit une observation.

« Le cache XDG résout toutes les fenêtres blanches WebKitGTK » serait une généralisation injustifiée.

« Les tests Rust passent » n'équivaut pas à « le trajet graphique IPC complet est certifié ».

Un exécutable fonctionnel sur une machine ne prouve pas la portabilité vers toutes les distributions Linux.

## Confidentialité des rapports publics

Avant une Issue ou une Pull Request, supprimer les noms d'utilisateur, chemins personnels, identifiants, secrets, informations de dépôts privés et adresses d'infrastructure.

Ne pas publier de code, journal ou capture propriétaire sans autorisation.

Pour le cas de la fenêtre blanche, consulter [le dépannage](troubleshooting.fr.md) et [le contournement XDG](xdg-cache-workaround.fr.md).

## Portée

Ce document est un retour d'expérience de compatibilité, pas une matrice de support constructeur ni une certification de sécurité ou de production.
