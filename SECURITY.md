# Security policy / Politique de sécurité

This repository is **documentation and an example script**, not a sandbox, package manager or published binary.

## Public reports

Do not publish credentials, SSH keys, personal file paths, public IP addresses connected to private infrastructure, internal hostnames, source code or proprietary logs. Redact sensitive values **before** opening an Issue or Pull Request.

## Shell script safety

Read scripts before running them. The example launcher starts a program **you select**; cache isolation does **not** restrict its filesystem, network, or system permissions. It must not run as root. Avoid global cache deletion.

## Vulnerability reporting

For potential private security vulnerabilities, contact the maintainer through the repository's GitHub private vulnerability reporting feature **if it has been enabled**. Otherwise, do not post exploitable secrets or private details in public Issues; seek a private maintainer contact channel first.

## Français

Les Issues sont publiques. Retirez les identifiants, chemins personnels, clés et journaux sensibles. Le cache XDG séparé ne protège pas contre un exécutable malveillant : ne lancez que des binaires de confiance. N'exécutez pas les exemples en root.
