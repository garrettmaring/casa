#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/lib/casa.sh"

ROOT="$(casa_repo_root)"
PACKAGES_DIR="$ROOT/packages"
APPS_DIR="$SCRIPT_DIR/apps"

install_app() {
  local app=${1:?app is required}
  local installer="$APPS_DIR/install-$app.sh"

  [ -x "$installer" ] || die "No installer found for app '$app' ($installer)"
  "$installer"
}

while IFS= read -r app; do
  [ -n "$app" ] || continue
  install_app "$app"
done < <(read_manifest "$PACKAGES_DIR/apps.txt")

log "Native app installation complete"
