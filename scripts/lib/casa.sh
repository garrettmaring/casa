#!/usr/bin/env bash

set -euo pipefail

casa_repo_root() {
  local script_dir
  script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
  cd -- "$script_dir/../.." >/dev/null 2>&1 && pwd
}

log() {
  printf '==> %s\n' "$*"
}

warn() {
  printf 'warning: %s\n' "$*" >&2
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

read_manifest() {
  local manifest=${1:?manifest is required}
  grep -Ev '^[[:space:]]*($|#)' "$manifest" || true
}

brew_bin() {
  if [ -x /opt/homebrew/bin/brew ]; then
    printf '/opt/homebrew/bin/brew\n'
    return 0
  fi

  if [ -x /usr/local/bin/brew ]; then
    printf '/usr/local/bin/brew\n'
    return 0
  fi

  command -v brew 2>/dev/null || return 1
}

ensure_brew_shellenv() {
  local brew_path
  brew_path="$(brew_bin || true)"
  [ -n "$brew_path" ] || return 0
  eval "$("$brew_path" shellenv)"
}

backup_existing_path() {
  local path=${1:?path is required}
  local backup_root="${CASA_BACKUP_ROOT:-$HOME/.casa-backups}"
  local timestamp

  [ -e "$path" ] || [ -L "$path" ] || return 0

  timestamp="$(date +%Y%m%d%H%M%S)"
  mkdir -p "$backup_root"
  mv "$path" "$backup_root/$(basename "$path").$timestamp"
}

link_with_backup() {
  local source_path=${1:?source is required}
  local target_path=${2:?target is required}

  mkdir -p "$(dirname "$target_path")"

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    return 0
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    backup_existing_path "$target_path"
  fi

  ln -s "$source_path" "$target_path"
}

ensure_command_line_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi

  log "Installing Xcode Command Line Tools"
  xcode-select --install >/dev/null 2>&1 || true
  die "Finish the Xcode Command Line Tools install, then rerun bootstrap."
}
