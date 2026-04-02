#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/lib/casa.sh"

ROOT="$(casa_repo_root)"
PACKAGES_DIR="$ROOT/packages"

load_manifest() {
  local manifest=${1:?manifest is required}
  local -n target_ref=${2:?target array name is required}

  mapfile -t target_ref < <(read_manifest "$manifest")
}

install_brew_manifest() {
  local mode=${1:?mode is required}
  local manifest=${2:?manifest is required}
  local packages=()
  local package

  load_manifest "$manifest" packages

  for package in "${packages[@]}"; do
    [ -n "$package" ] || continue

    if [ "$mode" = "formula" ]; then
      brew list --versions "$package" >/dev/null 2>&1 || brew install "$package"
    else
      brew list --cask --versions "$package" >/dev/null 2>&1 || brew install --cask "$package"
    fi
  done
}

install_zgen() {
  if [ -d "$HOME/.zgen" ]; then
    return 0
  fi

  log "Installing zgen"
  git clone https://github.com/tarjoilija/zgen.git "$HOME/.zgen"
}

install_nvm_and_node() {
  if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    log "Installing nvm"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  fi

  # shellcheck source=/dev/null
  source "$HOME/.nvm/nvm.sh"

  log "Installing latest Node LTS"
  nvm install --lts
  nvm alias default 'lts/*'

  if command -v corepack >/dev/null 2>&1; then
    corepack enable
    corepack prepare pnpm@latest --activate
    corepack prepare yarn@stable --activate
  fi
}

install_npm_manifest() {
  local manifest=${1:?manifest is required}
  local packages=()
  local package

  load_manifest "$manifest" packages

  for package in "${packages[@]}"; do
    [ -n "$package" ] || continue
    npm ls -g --depth=0 "$package" >/dev/null 2>&1 || npm install -g "$package"
  done
}

setup_pyenv() {
  export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
  export PATH="$PYENV_ROOT/bin:$PATH"

  command -v pyenv >/dev/null 2>&1 || die "pyenv must be available before Python setup"

  eval "$(pyenv init -)"
  if command -v pyenv-virtualenv-init >/dev/null 2>&1; then
    eval "$(pyenv virtualenv-init -)"
  fi
}

install_pyenv_versions() {
  local manifest=${1:?manifest is required}
  local versions=()
  local version

  load_manifest "$manifest" versions

  for version in "${versions[@]}"; do
    [ -n "$version" ] || continue
    if pyenv install -s "$version"; then
      continue
    fi

    if [ "$version" = "2.7.18" ]; then
      warn "Skipping optional legacy Python $version because pyenv could not build it"
      continue
    fi

    die "pyenv could not install required Python $version"
  done
}

install_pip_manifest() {
  local pip_bin=${1:?pip is required}
  local manifest=${2:?manifest is required}
  local packages=()
  local package
  local pip_version

  load_manifest "$manifest" packages

  pip_version="$("$pip_bin" --version 2>/dev/null || true)"
  if [[ "$pip_version" == *"python 2.7"* ]]; then
    "$pip_bin" install --upgrade 'pip<21' 'setuptools<45' 'wheel<1'
  else
    "$pip_bin" install --upgrade pip setuptools wheel
  fi

  for package in "${packages[@]}"; do
    [ -n "$package" ] || continue
    "$pip_bin" install "$package"
  done
}

install_provider_virtualenvs() {
  local manifest=${1:?manifest is required}
  local entries=()
  local entry
  local version env_name packages_manifest

  load_manifest "$manifest" entries

  for entry in "${entries[@]}"; do
    IFS=' ' read -r version env_name packages_manifest <<<"$entry"
    [ -n "$version" ] || continue
    if [ ! -x "$PYENV_ROOT/versions/$version/bin/python" ]; then
      warn "Skipping $env_name because Python $version is not installed"
      continue
    fi

    if [ ! -d "$PYENV_ROOT/versions/$env_name" ]; then
      if ! pyenv virtualenv "$version" "$env_name"; then
        warn "Skipping $env_name because pyenv virtualenv creation failed"
        continue
      fi
    fi

    install_pip_manifest "$PYENV_ROOT/versions/$env_name/bin/pip" "$ROOT/$packages_manifest"
  done
}

install_rbenv_ruby() {
  command -v rbenv >/dev/null 2>&1 || return 0
  eval "$(rbenv init - bash)"

  local latest_ruby
  latest_ruby="$(rbenv install -l | awk '/^[0-9]+\.[0-9]+\.[0-9]+$/ { version = $1 } END { print version }')"
  [ -n "$latest_ruby" ] || return 0

  log "Installing Ruby $latest_ruby"
  rbenv install -s "$latest_ruby"
  rbenv global "$latest_ruby"
}

install_gem_manifest() {
  local manifest=${1:?manifest is required}
  local gems=()
  local gem_name

  if ! command -v gem >/dev/null 2>&1; then
    return 0
  fi

  load_manifest "$manifest" gems

  for gem_name in "${gems[@]}"; do
    [ -n "$gem_name" ] || continue
    gem list -i "^${gem_name}$" >/dev/null 2>&1 || gem install "$gem_name"
  done

  if command -v rbenv >/dev/null 2>&1; then
    rbenv rehash
  fi
}

install_rustup() {
  if ! command -v rustup >/dev/null 2>&1; then
    log "Installing rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  "$HOME/.cargo/bin/rustup" default stable
}

install_foundry() {
  if [ ! -x "$HOME/.foundry/bin/foundryup" ]; then
    log "Installing foundryup"
    curl -fsSL https://foundry.paradigm.xyz | bash
  fi

  "$HOME/.foundry/bin/foundryup"
}

install_fonts() {
  log "Installing Nerd Font symbols"
  mkdir -p "$HOME/Library/Fonts"
  cp "$ROOT/fonts/Symbols-2048-em Nerd Font Complete.ttf" "$HOME/Library/Fonts/"
}

ensure_conda_home_link() {
  local conda_base

  if ! command -v conda >/dev/null 2>&1; then
    return 0
  fi

  conda_base="$(conda info --base 2>/dev/null || true)"
  [ -n "$conda_base" ] || return 0

  if [ "$conda_base" != "$HOME/miniforge3" ]; then
    ln -sfn "$conda_base" "$HOME/miniforge3"
  fi
}

ensure_command_line_tools

if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

ensure_brew_shellenv

log "Installing Homebrew formulae"
install_brew_manifest formula "$PACKAGES_DIR/brew-formulas.txt"

if [ "${CASA_INSTALL_OPTIONAL_FORMULAS:-0}" = "1" ] && [ -f "$PACKAGES_DIR/brew-formulas-optional.txt" ]; then
  log "Installing optional Homebrew formulae"
  install_brew_manifest formula "$PACKAGES_DIR/brew-formulas-optional.txt"
fi

log "Installing Homebrew casks"
install_brew_manifest cask "$PACKAGES_DIR/brew-casks.txt"
ensure_conda_home_link

if [ "${CASA_INSTALL_OPTIONAL_CASKS:-0}" = "1" ] && [ -f "$PACKAGES_DIR/brew-casks-optional.txt" ]; then
  log "Installing optional Homebrew casks"
  install_brew_manifest cask "$PACKAGES_DIR/brew-casks-optional.txt"
fi

install_zgen
install_nvm_and_node

log "Installing global npm packages"
install_npm_manifest "$PACKAGES_DIR/npm-global.txt"

setup_pyenv

log "Installing pyenv Python versions"
install_pyenv_versions "$PACKAGES_DIR/pyenv-versions.txt"

log "Installing Neovim provider virtualenvs"
install_provider_virtualenvs "$PACKAGES_DIR/python-provider-virtualenvs.txt"

install_rbenv_ruby

log "Installing global Ruby gems"
install_gem_manifest "$PACKAGES_DIR/gem-global.txt"

install_rustup
install_foundry
install_fonts

log "Package installation complete"
