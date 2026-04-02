#!/usr/bin/env bash

set -euo pipefail

readonly CASA_REPO_URL="${CASA_REPO_URL:-https://github.com/garrettmaring/casa.git}"
readonly CASA_TARGET_DIR="${CASA_TARGET_DIR:-$HOME/Developer/casa}"

mkdir -p "$(dirname "$CASA_TARGET_DIR")"

if [ ! -d "$CASA_TARGET_DIR/.git" ]; then
  git clone "$CASA_REPO_URL" "$CASA_TARGET_DIR"
else
  git -C "$CASA_TARGET_DIR" pull --ff-only
fi

exec "$CASA_TARGET_DIR/scripts/bootstrap.sh"
