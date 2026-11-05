# Working with npm and Cargo when network access is unavailable

[Back to the README](../README.md) · [Version française](offline-dependencies.fr.md)

A development environment can fail to resolve package registries even when the host computer has working internet access. Before changing DNS settings or reinstalling tooling, check where the failure actually occurs.

## 1. Diagnose the environment

Run these read-only checks in the affected environment and in a normal host terminal:

```bash
getent ahosts registry.npmjs.org
getent ahosts static.rust-lang.org

curl -I --connect-timeout 5 --max-time 10 \
  https://registry.npmjs.org/
```

Compare the results. A DNS failure inside an isolated development environment does not necessarily mean the host OS is misconfigured.

**Observed case:** Registry access failed in an isolated development environment but worked from the normal Linux terminal. Dependencies were then prepared through the working environment and used locally.

## 2. Verify an npm package archive

Obtain the expected package version from a trusted source using a network-enabled environment.

Before using a downloaded archive:

```bash
sha256sum /path/to/package.tgz
sha512sum /path/to/package.tgz
```

Compare the result against an independently trusted reference where available. If the registry publishes an integrity value, check that too.

A checksum computed only from the local archive proves the archive's fingerprint, **not its independent provenance or safety**.

## 3. Prepare an offline npm installation

After verifying an archive and reviewing the project lockfile, a controlled workflow may use:

```bash
npm cache add --offline --ignore-scripts \
  /path/to/verified-package.tgz

npm ci --offline --ignore-scripts \
  --no-audit --no-fund
```

Run installation commands only inside a project you own or are authorized to modify.

The second command assumes a compatible `package-lock.json` and an npm cache containing **all required dependencies and metadata**, not merely the one archive added above.

A successful cache import does not guarantee an offline installation.

**Important:** `--ignore-scripts` prevents lifecycle scripts from running during installation. Packages that require them may not work until the relevant steps are reviewed and performed safely.

## 4. Resolve Cargo dependencies offline

If the required crates and registry metadata are already available locally, check resolution with:

```bash
cargo metadata --offline --locked \
  --format-version 1 \
  --manifest-path src-tauri/Cargo.toml
```

`--offline` prevents Cargo network access. `--locked` prevents changes that would require updating `Cargo.lock`.

A successful metadata command proves dependency resolution under those conditions. It does not prove compilation or application behavior.

## 5. Record the results

Keep a small record containing the OS and tool versions, command executed, exit code, expected result, actual result and any missing dependency.

Avoid changing global caches or disabling certificate verification to work around DNS failures.

## Limitations

These techniques were useful in one documented Linux/Tauri development case. Their applicability depends on your versions, lockfiles, cache contents and operating environment.

## Official references

- [npm cache](https://docs.npmjs.com/cli/cache/)
- [npm ci](https://docs.npmjs.com/cli/commands/npm-ci/)
- [Cargo metadata](https://doc.rust-lang.org/cargo/commands/cargo-metadata.html)
