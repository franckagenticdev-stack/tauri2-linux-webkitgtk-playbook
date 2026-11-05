# Compatibility notes and evidence levels

[Back to the README](../README.md) · [Version française](compatibility.fr.md)

This guide records a dated Linux/Tauri case-study environment and explains how to describe test results without making unsupported compatibility claims.

## Observed environment — November 2026

| Component | Observed version |
|---|---|
| Distribution | Zorin OS 18.1, Ubuntu 24.04 base |
| Architecture | Linux x86_64 |
| Node.js | 20.20.2 |
| npm | 10.8.2 |
| Rust / Cargo | 1.99.1 |
| Tauri CLI | 2.12.4 |
| Tauri JavaScript API | 2.12.4 |
| Tauri Rust crate | 2.12.5 |
| WebKitGTK | 2.52.6 |
| GTK | 3.24.41 |
| libsoup | 3.4.4 |

These were observed versions, **not minimum requirements or recommendations to use the latest versions**.

A mismatch between the CLI, JavaScript API and Rust crate versions does not automatically prove incompatibility. Verify the actual resolved dependency graph, the Tauri compatibility guidance and the behavior of the tested application.

## Inspect your own system

Read-only checks may include:

```bash
cat /etc/os-release
uname -m
node --version
npm --version
rustc --version
cargo --version
pkg-config --modversion webkit2gtk-4.1
```

Record missing tools rather than immediately installing packages.

## Suggested evidence terminology

**Observed PASS:** An explicitly recorded check succeeded in the stated environment.

**Observed FAIL:** An explicitly recorded check failed.

**Workaround verified locally:** An alternative procedure changed the observed result, without proving the underlying cause.

**Partially verified:** Some layers or observations passed, but an important end-to-end test is missing.

**Not tested:** No evidence exists for that claim.

**Hypothesis:** A possible explanation that has not been demonstrated.

## Examples of careful reporting

“An isolated XDG cache restored rendering on the tested machine” is supported by a local observation.

“An isolated XDG cache fixes WebKitGTK blank windows on Linux” would be too broad.

“Rust tests passed” does not mean “the complete desktop IPC path is certified.”

A working binary on one workstation does not establish portability to other Linux distributions.

## Sharing test reports safely

Before posting an Issue or Pull Request:

- Remove local usernames, filesystem paths and environment secrets.
- Redact private repository information and infrastructure addresses.
- Exclude proprietary code, logs and screenshots unless you are authorized to share them.
- Include only the minimum versions and reproduction steps needed to understand the problem.

For the original blank-window investigation, see [troubleshooting](troubleshooting.md) and the [XDG cache workaround](xdg-cache-workaround.md).

## Scope

This is a case-study compatibility reference, not a product support matrix, a security certification or a promise of cross-platform behavior.
