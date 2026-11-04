# Troubleshooting blank Tauri 2 windows on Linux

[Français](troubleshooting.fr.md) · [Back to README](../README.md)

**Symptoms observed in one case study**: React/Vite rendered correctly in a normal browser, but the native Tauri/WebKitGTK window was blank; a WebKit web process consumed unusually high CPU. That observation does not prove a particular underlying fault.

## Evidence-first decision path

1. Confirm whether the **frontend browser version works** and record URL, status and console messages.
2. Check `dist/index.html`, built CSS/JS paths and Tauri `frontendDist`, `devUrl`, and CSP configuration.
3. Distinguish **`tauri dev`** (depends on the dev server) from **`tauri build --debug --no-bundle`** (standalone build).
4. If the native window remains blank, run a controlled experiment with a **new temporary XDG cache**; do **not** clear global caches.
5. If the isolated cache works, test a persistent per-app cache with a guarded launcher; compare actual rendering and app exit code.
6. Record OS version, window system, GTK/WebKitGTK version, Tauri CLI version, logs, CPU symptoms, flags and exact results.

## Temporary cache experiment

```bash
# Substitute the path of YOUR OWN trusted application binary.
BIN="/absolute/path/to/your/tauri/application"
test -x "$BIN" || { echo 'Invalid binary'; exit 1; }
TEST_CACHE="$(mktemp -d /tmp/tauri2-xdg-test.XXXXXX)" || exit 1
printf 'Temporary cache location: %s
' "$TEST_CACHE"
env XDG_CACHE_HOME="$TEST_CACHE" "$BIN"
# Inspect the path before any manual cleanup. Do not delete global caches.
```

This test is not an installer and makes no changes to the default cache location. The launched application may still access other resources according to its own behavior.

## Connection refused to `127.0.0.1:5173`

If a debug binary was last produced by `tauri dev`, it may still be configured for `devUrl`. Recreate the standalone build after the last dev session, then test with Vite stopped. Do not misinterpret a successful `vite build` as proof that the native executable is standalone.

## Limitations

Cache isolation worked in the reported environment, but **the precise root cause (including the role of Fontconfig symlinks) remains unverified**. Please report counterexamples rather than assuming the workaround is universal.
