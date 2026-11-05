# Testing React, Tauri IPC and Rust across boundaries

[Back to the README](../README.md) · [Version française](testing.fr.md)

In a Tauri application, a Rust unit test, a TypeScript test and a successful WebView interaction prove different things. Treat them as separate evidence rather than assuming one covers the others.

## 1. Separate responsibilities

A practical design keeps:

- **React:** display, user feedback and explicit actions.
- **TypeScript client:** IPC invocation and runtime response validation.
- **Tauri commands:** transport boundary between frontend and Rust.
- **Rust domain:** input validation, business rules and state transitions.
- **Local fixtures:** controlled test data.

This helps test the business rules without requiring a running desktop window for every scenario.

## 2. Validate both sides of the IPC contract

Tauri commands can be invoked from JavaScript using `@tauri-apps/api/core`.

Command arguments normally use camelCase keys on the JavaScript side. Rust parameters, serialization attributes and the frontend contract must agree on the actual JSON representation.

Test at least:

- valid requests and responses;
- missing and unknown fields;
- incompatible contract versions;
- invalid discriminants and null values;
- mismatched response types;
- rejected commands and transport failures.

TypeScript types alone do **not** validate untrusted runtime JSON. Parse and validate the received payload before displaying or acting on it.

## 3. Use deterministic fixtures

Prefer a fixed test fixture and an injectable clock when testing decisions and timestamps.

A read-only fixture should be checked before and after the operation. Tests should also verify that unsupported transitions leave the original state unchanged.

Avoid allowing a request to select arbitrary filesystem paths.

## 4. Test retries and concurrency

For operations that may be repeated, test these cases separately:

- identical request replay;
- same operation ID with a different payload;
- concurrent duplicate requests;
- bounded waiting or timeout;
- failure while recording evidence;
- uncertain outcomes after an injected failure.

If your implementation retains operation records only in memory, do not claim persistence or idempotency across process restarts.

## 5. Build an evidence matrix

| Test level | What it supports | What it does not prove |
|---|---|---|
| Rust unit tests | Domain rules and local behavior | Real frontend invocation |
| TypeScript tests | Parsing and client-side handling | Native WebView interaction |
| Cross-language JSON tests | Compatibility of tested payloads | Every runtime transport path |
| Native build | Compilation and packaging inputs | Correct GUI behavior |
| Observed GUI test | Visible result in a tested session | Complete internal IPC trace |
| Isolated-process test | Isolation of the tested process | Network isolation of every GUI subprocess |

## 6. Document partial verification

A screenshot showing the expected state is useful evidence. It is not a substitute for an instrumented trace of the click, IPC request, Rust execution and response.

Likewise, restricting one test process does not establish that every GTK or WebKitGTK subprocess was restricted.

## Limitations

The techniques here are derived from a controlled local simulation. They are not a certification of production releases, remote deployments or a complete security boundary.

## Official reference

[Tauri — Calling Rust from the Frontend](https://v2.tauri.app/develop/calling-rust/)
