#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/../lib/casa.sh"

KITTY_APP="/Applications/kitty.app"
KITTY_BIN_DIR="$HOME/.local/bin"
KITTY_BIN="$KITTY_APP/Contents/MacOS/kitty"
KITTEN_BIN="$KITTY_APP/Contents/MacOS/kitten"

log "Installing kitty via the official installer"
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

if [ ! -x "$KITTY_BIN" ]; then
  die "kitty install completed but $KITTY_BIN was not found"
fi

mkdir -p "$KITTY_BIN_DIR"
ln -sfn "$KITTY_BIN" "$KITTY_BIN_DIR/kitty"
[ -x "$KITTEN_BIN" ] && ln -sfn "$KITTEN_BIN" "$KITTY_BIN_DIR/kitten"

log "kitty is available at $KITTY_BIN"
