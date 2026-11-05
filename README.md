# Tauri 2 on Linux — WebKitGTK Troubleshooting Playbook

[Version française](README.fr.md) · [Installation](docs/installation.md) · [Troubleshooting](docs/troubleshooting.md) · [Isolated XDG cache workaround](docs/xdg-cache-workaround.md) · [Report a problem](https://github.com/franckagenticdev-stack/tauri2-linux-webkitgtk-playbook/issues/new/choose)

A practical, reproducible troubleshooting playbook for **Tauri 2 + Rust + React / TypeScript + Vite** on Linux, with particular attention to **blank WebKitGTK windows**, frontend asset loading and local cache isolation.

> **Evidence, not a universal fix.** The isolated-cache workaround was **observed to restore rendering in one Zorin OS 18.1 / Ubuntu 24.04-based development environment** (November 2026). No root-cause proof or universal guarantee is claimed. Test locally and report what you observe.

## Quick diagnosis

| Symptom | First check | Evidence from the case study |
| --- | --- | --- |
| `cargo check` fails around icon generation | Is `src-tauri/icons/icon.png` a valid image? | Missing PNG blocked the check; adding an image unblocked it. |
| Native Tauri window is blank but Vite works in browser | Launch with a **new isolated XDG cache**, without changing your global cache | Rendering returned with an empty `XDG_CACHE_HOME`; a dedicated persistent cache also worked. |
| `Could not connect to 127.0.0.1:5173` after stopping Vite | Was the executable last produced by `tauri dev`? | An overwritten debug executable required Vite; rebuilding standalone debug fixed it. |
| High CPU use by WebKit web process | Gather process details; compare with isolated-cache run | High CPU was observed, but the exact WebKitGTK/Fontconfig cause was **not proven**. |

## Start here

1. Read the [Linux prerequisites](docs/installation.md) (check existing tools before installing anything).
2. Reproduce the issue and collect evidence using [troubleshooting steps](docs/troubleshooting.md).
3. Test [XDG cache isolation](docs/xdg-cache-workaround.md) **without deleting your existing caches**.
4. Adapt and inspect the [example launcher](examples/launch-with-isolated-xdg-cache.sh) for your application.
5. Submit an [Issue](https://github.com/franckagenticdev-stack/tauri2-linux-webkitgtk-playbook/issues/new/choose) with environment and result. Do not post secrets, access tokens or personal paths.

## More developer guides

Beyond WebKitGTK troubleshooting, these guides cover related lessons from a controlled Linux/Tauri development case:

- [Offline npm and Cargo dependencies](docs/offline-dependencies.md)
- [Reproducible dependency changes and standalone builds](docs/reproducible-builds.md)
- [Testing React, Tauri IPC and Rust](docs/testing.md)
- [Compatibility notes and evidence levels](docs/compatibility.md)

Each guide separates observed results from general recommendations and unverified assumptions. Examples are documentation, not automatically executed procedures.

## Verified environment (case study, not a minimum requirement)

- Zorin OS 18.1, Ubuntu 24.04 (“noble”) base.
- Tauri CLI 2.12.4, Rust/Cargo 1.99.1, Vite 6.4.4, React/TypeScript.
- A native debug build with `tauri build --debug --no-bundle` succeeded; the WebView rendered after cache isolation and closed with exit code 0.
- The root cause behind the original cache-related symptom remains undetermined.

## Community tracking

Use **Stars** to bookmark, **Watch** for GitHub notifications, **Issues** for reproducible bug reports, **Pull Requests** for reviewed improvements, and **Discussions** for questions when the repository owner enables Discussions in GitHub settings. GitHub Insights may show traffic/fork data depending on GitHub's features and retention.

## Scope and safety

- This repository is **documentation and an example launcher**, not a distribution of application code or compiled binaries.
- No system installation or privileged command executes by opening this repository.
- Never copy shell examples blindly: review paths, versions, mount behavior and permissions on your machine.
- Do not delete or manipulate the normal user cache to diagnose this issue.
- See [Security](SECURITY.md), [Contributing](CONTRIBUTING.md), and [Changelog](CHANGELOG.md).

## Upstream reference

Official Tauri 2 Linux prerequisites: https://v2.tauri.app/start/prerequisites/

## License

Released under the [MIT License](LICENSE), copyright © 2026 franckagenticdev-stack. Reuse and contributions are welcome under the license terms. The documented workaround is provided **as-is**, without a claim of universal effectiveness.
