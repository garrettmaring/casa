#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
# shellcheck source=scripts/lib/casa.sh
source "$SCRIPT_DIR/lib/casa.sh"

ROOT="$(casa_repo_root)"
PACKAGES_DIR="$ROOT/packages"
NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
PACKER_DIR="$NVIM_DATA_DIR/site/pack/packer/start/packer.nvim"
COMPILED_LOADER="$ROOT/.config/nvim/plugin/packer_compiled.lua"
MASON_PACKAGES_DIR="$NVIM_DATA_DIR/mason/packages"
TREE_SITTER_PARSER_DIR="$NVIM_DATA_DIR/site/parser"
LUASNIP_DIR="$NVIM_DATA_DIR/site/pack/packer/start/LuaSnip"
CASA_NVIM_BIN_DIR="$NVIM_DATA_DIR/casa-bin"

write_casa_yarn_shim() {
  mkdir -p "$CASA_NVIM_BIN_DIR"

  cat > "$CASA_NVIM_BIN_DIR/yarn" <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)/$(basename -- "${BASH_SOURCE[0]}")"
REAL_YARN=""

while IFS= read -r candidate; do
  [ -n "$candidate" ] || continue
  if [ "$candidate" != "$SCRIPT_PATH" ]; then
    REAL_YARN="$candidate"
    break
  fi
done < <(which -a yarn 2>/dev/null || true)

[ -n "$REAL_YARN" ] || {
  echo "error: could not locate the real yarn binary" >&2
  exit 1
}

if [ "$#" -eq 3 ] && [ "$1" = "info" ] && [ "$3" = "--json" ] && [ ! -f package.json ]; then
  exec npm info "$2" --json
fi

exec "$REAL_YARN" "$@"
EOF

  chmod +x "$CASA_NVIM_BIN_DIR/yarn"
}

refresh_packer_repo_checkout() {
  local repo_dir=${1:?repo dir is required}
  local stale_origin_pattern=${2:?stale origin pattern is required}
  local origin
  local stale_module_file="$repo_dir/lua/treesitter-context.lua"

  [ -d "$repo_dir/.git" ] || return 0

  origin="$(git -C "$repo_dir" remote get-url origin 2>/dev/null || true)"
  if [ -f "$stale_module_file" ] && grep -q "nvim-treesitter.ts_utils" "$stale_module_file"; then
    log "Backing up stale $(basename "$repo_dir") checkout so packer can clone a fresh copy"
    backup_existing_path "$repo_dir"
    return 0
  fi

  case "$origin" in
    *"$stale_origin_pattern"*)
      log "Backing up stale $(basename "$repo_dir") checkout so packer can clone a fresh copy"
      backup_existing_path "$repo_dir"
      ;;
  esac
}

ensure_brew_shellenv

run_nvim_bootstrap() {
  CASA_NVIM_BOOTSTRAP=1 nvim --headless --noplugin "$@"
}

run_nvim_bootstrap_with_plugins() {
  CASA_NVIM_BOOTSTRAP=1 CASA_NVIM_BOOTSTRAP_LOAD_PLUGINS=1 nvim --headless "$@"
}

missing_mason_packages() {
  local manifest=${1:?manifest is required}
  local package
  local missing=()

  while IFS= read -r package; do
    [ -n "$package" ] || continue
    [ -d "$MASON_PACKAGES_DIR/$package" ] || missing+=("$package")
  done < <(read_manifest "$manifest")

  printf '%s\n' "${missing[@]}"
}

missing_treesitter_parsers() {
  local manifest=${1:?manifest is required}
  local parser
  local missing=()

  while IFS= read -r parser; do
    [ -n "$parser" ] || continue
    [ -f "$TREE_SITTER_PARSER_DIR/$parser.so" ] || missing+=("$parser")
  done < <(read_manifest "$manifest")

  printf '%s\n' "${missing[@]}"
}

command -v nvim >/dev/null 2>&1 || die "Neovim must be installed before running install-neovim.sh"

write_casa_yarn_shim

if [ ! -d "$PACKER_DIR" ]; then
  log "Installing packer.nvim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
fi

refresh_packer_repo_checkout \
  "$NVIM_DATA_DIR/site/pack/packer/start/nvim-treesitter-context" \
  "lewis6991/nvim-treesitter-context"

if [ -f "$COMPILED_LOADER" ]; then
  log "Removing stale packer loader"
  rm -f "$COMPILED_LOADER"
fi

log "Syncing Neovim plugins"
run_nvim_bootstrap \
  "+autocmd User PackerComplete quitall" \
  "+PackerSync"

MASON_PACKAGES="$(missing_mason_packages "$PACKAGES_DIR/mason-packages.txt" | xargs)"
if [ -n "$MASON_PACKAGES" ]; then
  log "Installing Mason packages"
  run_nvim_bootstrap_with_plugins "+lua require('mason').setup()" "+MasonInstall $MASON_PACKAGES" "+qall" || warn "MasonInstall returned a non-zero status"
fi

OPTIONAL_MASON_PACKAGES_FILE="$PACKAGES_DIR/mason-packages-optional.txt"
if [ "${CASA_INSTALL_OPTIONAL_MASON:-0}" = "1" ] && [ -f "$OPTIONAL_MASON_PACKAGES_FILE" ]; then
  OPTIONAL_MASON_PACKAGES="$(missing_mason_packages "$OPTIONAL_MASON_PACKAGES_FILE" | xargs)"
  if [ -n "$OPTIONAL_MASON_PACKAGES" ]; then
    log "Installing optional Mason packages"
    run_nvim_bootstrap_with_plugins "+lua require('mason').setup()" "+MasonInstall $OPTIONAL_MASON_PACKAGES" "+qall" || warn "Optional MasonInstall returned a non-zero status"
  fi
fi

TREE_SITTER_PARSERS="$(missing_treesitter_parsers "$PACKAGES_DIR/treesitter-parsers.txt" | xargs)"
if [ -n "$TREE_SITTER_PARSERS" ]; then
  command -v tree-sitter >/dev/null 2>&1 || die "tree-sitter CLI must be installed before Tree-sitter parser bootstrap"
  log "Installing Tree-sitter parsers"
  TREE_SITTER_PARSERS_CSV="$(missing_treesitter_parsers "$PACKAGES_DIR/treesitter-parsers.txt" | paste -sd, -)"
  CASA_TREE_SITTER_PARSERS="$TREE_SITTER_PARSERS_CSV" \
    CASA_NVIM_BOOTSTRAP=1 \
    CASA_NVIM_BOOTSTRAP_LOAD_PLUGINS=1 \
    nvim --headless \
      "+lua require('nvim-treesitter.install').install(vim.split(vim.env.CASA_TREE_SITTER_PARSERS, ','), { summary = true }):wait()" \
      "+qall" || warn "Tree-sitter parser installation returned a non-zero status"
fi

log "Installing Firenvim browser integration"
run_nvim_bootstrap_with_plugins "+silent! FirenvimInstall" "+qall" || warn "FirenvimInstall returned a non-zero status"

if [ -d "$LUASNIP_DIR" ]; then
  log "Installing LuaSnip jsregexp support"
  make -C "$LUASNIP_DIR" install_jsregexp >/dev/null
fi

log "Refreshing remote plugin manifest"
run_nvim_bootstrap_with_plugins "+silent! UpdateRemotePlugins" "+qall" || warn "UpdateRemotePlugins returned a non-zero status"

log "Compiling packer loader"
run_nvim_bootstrap "+PackerCompile" "+qall"

log "Neovim bootstrap complete"
