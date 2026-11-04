# Linux prerequisites and preparation (Tauri 2)

[Français](installation.fr.md) · [Back to README](../README.md)

This checklist is for Debian/Ubuntu-family desktop Linux. Do **not** infer that it will match every distribution or an existing development workstation.

## 1. Inspect the environment (read-only)

```bash
cat /etc/os-release
uname -m
node --version
npm --version
rustc --version
cargo --version
pkg-config --modversion webkit2gtk-4.1
```

Missing commands may produce errors; record them rather than immediately changing the system. Check the filesystem type and permissions of the intended workspace.

## 2. Check native build dependencies

The Tauri 2 documentation lists `libwebkit2gtk-4.1-dev`, `build-essential`, `curl`, `wget`, `file`, `libxdo-dev`, `libssl-dev`, `libayatana-appindicator3-dev`, and `librsvg2-dev` for Debian-based Linux. See the [official prerequisites](https://v2.tauri.app/start/prerequisites/).

Use **simulation first**, after evaluating package availability and distribution compatibility:

```bash
apt-get -s install libwebkit2gtk-4.1-dev build-essential curl wget file   libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev
```

Do not execute `sudo apt install` without your own review and explicit approval. This repository does **not** require or initiate any installation.

## 3. Rust and JavaScript

Verify that Rust and Cargo are available. For project-specific toolchains, point `RUSTUP_HOME` and `CARGO_HOME` to directories **owned by the developer** and understand how the PATH and caches are isolated. Review the official Rust installation and Tauri installation instructions before downloading installers or changing the toolchain.

## 4. Validate the application before desktop testing

- Check the Tauri CLI version, project scripts and `src-tauri/tauri.conf.json`.
- Ensure required resources (including `src-tauri/icons/icon.png`, where the project expects one) exist.
- Run `cargo check` with appropriate environment variables and resource limits.
- Build a **standalone** debug executable with the project CLI: `tauri build --debug --no-bundle` (script/CLI invocation depends on your project).
- Stop Vite before validating a supposed standalone executable.
- Adopt a dedicated XDG cache before the GUI validation, and record the closing exit code.

**Avoid mixing** `tauri dev` and a standalone debug executable at the same output path without rebuilding, as the example project exposed a confusing overwritten executable.
