#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/lib/casa.sh"

ROOT="$(casa_repo_root)"
EXPECTED_ROOT="${CASA_TARGET_DIR:-$HOME/Developer/casa}"

if [ "$ROOT" != "$EXPECTED_ROOT" ]; then
  warn "Casa is checked out at $ROOT"
  warn "Expected location for this machine is $EXPECTED_ROOT"
  warn "Continuing with the current checkout. Set CASA_TARGET_DIR to silence this."
fi

"$SCRIPT_DIR/install-packages.sh"
"$SCRIPT_DIR/install-apps.sh"
"$SCRIPT_DIR/link-dotfiles.sh"
"$SCRIPT_DIR/install-neovim.sh"

log "Casa bootstrap complete"
log "Open a new shell session to pick up the linked config."
