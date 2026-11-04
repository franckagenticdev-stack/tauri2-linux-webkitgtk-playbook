# Workaround: isolated `XDG_CACHE_HOME` for Tauri 2 / WebKitGTK

[Français](xdg-cache-workaround.fr.md) · [Back to README](../README.md)

> **Case study result (November 2026):** A Tauri 2 native blank window rendered correctly when launched with a clean temporary `XDG_CACHE_HOME`. A dedicated persistent per-application cache then worked. This is an **empirical workaround**, not a proven WebKitGTK defect fix.

## Why isolate instead of delete?

Changing an application's cache root lets you compare behavior while leaving the normal `~/.cache` untouched. It also limits the scope of the experiment. Cache isolation **does not** sandbox the process or prevent filesystem/network access by the app.

## Minimal experiment

```bash
BIN="/absolute/path/to/your/verified/tauri/binary"
test -x "$BIN" || exit 1
TEMP_CACHE="$(mktemp -d /tmp/tauri-xdg.XXXXXX)" || exit 1
printf 'Using temporary cache: %s
' "$TEMP_CACHE"
env XDG_CACHE_HOME="$TEMP_CACHE" "$BIN"
printf 'APP_EXIT=%s
' "$?"
```

If the display changes, verify the same executable, flags and environment were used apart from `XDG_CACHE_HOME`. Note the exact result and do not generalize from a single test.

## Persistent launcher

See [the example shell launcher](../examples/launch-with-isolated-xdg-cache.sh). It requires a trusted absolute executable path and a unique application slug. It checks for root, symlinked cache directories and ownership; it creates only an app-specific directory below `$HOME/.cache`.

Example invocation **after reviewing the script**:

```bash
bash examples/launch-with-isolated-xdg-cache.sh /absolute/path/to/app my-app
```

On some unusual mounts, `chmod` does not imply effective POSIX permissions. The example fails closed if owner/mode checks cannot be satisfied, rather than changing permissions elsewhere.

## Limitations and warnings

- **Do not** rename, delete, chmod or replace the global `~/.cache` or Fontconfig directories.
- **Do not** use `sudo` to run the launcher.
- **Do not** assume a successful standalone build implies the window renders.
- **Do not** assume this workaround fixes all blank screens or explains all high CPU symptoms.
- Run only **trusted application executables**; this launcher is not a security sandbox.
- Record versions, display server (X11/Wayland), command used, result and exit code when reporting back.
