#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/lib/casa.sh"

ROOT="$(casa_repo_root)"
CONFIG_SOURCE="$ROOT/.config"
CONFIG_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}"

log "Linking Casa-managed config into $CONFIG_TARGET"

for entry in \
  .base16_theme \
  .fzf.bash \
  .fzf.zsh \
  .screenrc \
  .tmux.conf \
  .zshenv \
  .zshrc \
  colors \
  kitty \
  nvim \
  starship.toml
do
  link_with_backup "$CONFIG_SOURCE/$entry" "$CONFIG_TARGET/$entry"
done

log "Linking home-directory entrypoints"

link_with_backup "$CONFIG_TARGET/.zshenv" "$HOME/.zshenv"
link_with_backup "$CONFIG_TARGET/.zshrc" "$HOME/.zshrc"
link_with_backup "$CONFIG_TARGET/.tmux.conf" "$HOME/.tmux.conf"
link_with_backup "$CONFIG_TARGET/.screenrc" "$HOME/.screenrc"
link_with_backup "$CONFIG_TARGET/.fzf.zsh" "$HOME/.fzf.zsh"
link_with_backup "$CONFIG_TARGET/.fzf.bash" "$HOME/.fzf.bash"
link_with_backup "$ROOT/.ripgreprc" "$HOME/.ripgreprc"

log "Dotfile linking complete"
