#!/usr/bin/env bash
# Example only: reviewed and executed by the user at their own discretion.
# Usage: bash launch-with-isolated-xdg-cache.sh /absolute/path/to/trusted/binary unique-app-slug
set -euo pipefail

if [[ "$(id -u)" -eq 0 ]]; then
  echo 'STOP: do not run this launcher as root.' >&2
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo 'Usage: bash launch-with-isolated-xdg-cache.sh /absolute/path/to/binary app-slug' >&2
  exit 2
fi

BIN="$1"
APP_ID="$2"

if [[ "$BIN" != /* || ! -f "$BIN" || ! -x "$BIN" || -L "$BIN" ]]; then
  echo 'STOP: supply an existing trusted absolute executable path (not a symlink).' >&2
  exit 1
fi
if [[ ! "$APP_ID" =~ ^[a-zA-Z0-9][a-zA-Z0-9_.-]*$ ]]; then
  echo 'STOP: app-slug may contain only letters, digits, underscore, dot and dash.' >&2
  exit 1
fi

CACHE="${HOME:?}/.cache/tauri2-${APP_ID}"
if [[ ! -d "$HOME/.cache" || -L "$HOME/.cache" || ! -O "$HOME/.cache" ]]; then
  echo 'STOP: expected owned, non-symlink ~/.cache directory.' >&2
  exit 1
fi
if [[ -e "$CACHE" || -L "$CACHE" ]]; then
  if [[ ! -d "$CACHE" || -L "$CACHE" || ! -O "$CACHE" ]]; then
    echo 'STOP: cache exists but is not an owned normal directory.' >&2
    exit 1
  fi
else
  (umask 077 && mkdir -- "$CACHE")
fi
chmod 700 -- "$CACHE"
if [[ "$(stat -c '%u' -- "$CACHE")" != "$(id -u)" || "$(stat -c '%a' -- "$CACHE")" != '700' || -L "$CACHE" ]]; then
  echo 'STOP: cache owner/mode/symlink verification failed.' >&2
  exit 1
fi

printf 'Launching with isolated cache: %s
' "$CACHE"
exec env XDG_CACHE_HOME="$CACHE" "$BIN"
