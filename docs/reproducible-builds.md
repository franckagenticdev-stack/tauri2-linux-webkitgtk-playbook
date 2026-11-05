# Reproducible dependency changes and standalone Tauri builds

[Back to the README](../README.md) · [Version française](reproducible-builds.fr.md)

A successful build is useful evidence, but it does not tell you exactly what changed. For a dependable development workflow, preserve the state before a dependency update and compare it with the state afterward.

## 1. Capture a BEFORE baseline

Identify the files that the operation is allowed to modify. In a typical npm/Rust/Tauri project, start with:

- `package.json`
- `package-lock.json`
- `src-tauri/Cargo.toml`
- `src-tauri/Cargo.lock`

If the files exist, record their checksums:

```bash
sha256sum package.json package-lock.json \
  src-tauri/Cargo.toml src-tauri/Cargo.lock
```

Create a separate, reviewed backup before modifying them. Never overwrite a previous backup without checking what it contains.

## 2. Keep dependency resolution controlled

For npm, prefer an existing reviewed lockfile and `npm ci` when the environment and project support it.

For Cargo, use `--locked` to require a consistent lockfile. Add `--offline` only when local dependency availability has been established.

An offline run is not automatically reproducible if the local cache is incomplete or contains a different dependency set.

## 3. Inspect the AFTER state

After an authorized change, compare versions and lockfile entries.

In an existing Git repository, a useful read-only check is:

```bash
git diff -- package.json package-lock.json \
  src-tauri/Cargo.toml src-tauri/Cargo.lock
```

Also compare the new checksums against the BEFORE baseline.

Look for unexpected version upgrades, altered package sources, changes to integrity metadata or additional packages outside the intended scope.

## 4. Distinguish dev and standalone builds

A Tauri development session may use a frontend server such as Vite. A standalone build should be tested without that development server.

In one Linux case, the executable under the debug output path required a stopped Vite server after a `tauri dev` session. Rebuilding with `tauri build --debug --no-bundle` restored standalone behavior.

This is an observed case, not a guarantee about every Tauri configuration.

When testing a standalone executable, record:

- which build command produced it;
- whether the development server is stopped;
- whether the window opens and renders;
- whether application shutdown succeeds.

See [Linux prerequisites](installation.md) and [troubleshooting](troubleshooting.md).

## 5. Plan rollback before relying on it

A rollback should verify the current file checksums, compare them with the expected AFTER state and stop if unrelated changes have appeared.

Restoring old lockfiles without reviewing intervening changes can cause new problems.

## Limitations

Checksums establish file identity. Successful builds establish compilation under tested conditions. Neither is proof of runtime security, graphical correctness or production readiness.

## Official references

- [npm ci](https://docs.npmjs.com/cli/commands/npm-ci/)
- [Cargo check](https://doc.rust-lang.org/cargo/commands/cargo-check.html)
- [Tauri CLI](https://v2.tauri.app/reference/cli/)
