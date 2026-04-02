# set global editor
export EDITOR=nvim

# set global ai
export AI="${AI:-claude}"

# Only force kitty TERM settings when actually running inside kitty.
if [ -n "${KITTY_PID:-}" ] || [ "${TERM_PROGRAM:-}" = "kitty" ]; then
  export TERM='xterm-kitty'
fi

export DEVELOPER_HOME="${DEVELOPER_HOME:-$HOME/Developer}"
export SANDBOX_HOME="${SANDBOX_HOME:-$DEVELOPER_HOME/Sandbox}"

prepend_path() {
  local dir=${1:?path entry is required}

  PATH=":$PATH:"
  PATH="${PATH//:$dir:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
  export PATH="$dir${PATH:+:$PATH}"
}

# config files
export CASA_CONFIG="${CASA_CONFIG:-$DEVELOPER_HOME/casa}"
export CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# engi
export ENGI_MONOREPO_DIR="${ENGI_MONOREPO_DIR:-$DEVELOPER_HOME/engi/engi}"

# nvm
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # load nvm completion

# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# fzf
[ -f "$CONFIG_HOME/.fzf.zsh" ] && source "$CONFIG_HOME/.fzf.zsh"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border none --info=inline --preview 'bat --color=always --style=plain {}' --preview-window '~3'" # style fzf ui

# source cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# local-only secrets and machine overrides
[ -f "$HOME/.zshenv.local" ] && . "$HOME/.zshenv.local"
[ -f "$CASA_CONFIG/.config/.zshenv.local" ] && . "$CASA_CONFIG/.config/.zshenv.local"

# conda
export CONDA_HOME="${CONDA_HOME:-$HOME/miniforge3}"
if [ -d "$CONDA_HOME/bin" ]; then
  export PATH="$CONDA_HOME/bin:$PATH"
fi

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"

if [ -d "/opt/homebrew/opt/openssl@1.1" ]; then
  export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"
elif [ -d "/opt/homebrew/opt/openssl@3" ]; then
  export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
  export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"
fi

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export PATH="$HOME/.foundry/bin:$PATH"

[ -d "$HOME/.local/bin" ] && prepend_path "$HOME/.local/bin"
[ -d "$HOME/bin" ] && prepend_path "$HOME/bin"
