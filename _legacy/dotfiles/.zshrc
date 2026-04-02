# echo "Performing minor ritual: Loading plugins, configuring shell, initializing environment managers..."

# Zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen oh-my-zsh
  zgen oh-my-zsh plugins/vi-mode
  zgen oh-my-zsh plugins/git
  zgen oh-my-zsh plugins/sudo
  zgen oh-my-zsh plugins/command-not-found
  zgen load zsh-users/zsh-completions src
  #zgen bundle colorize

  ## Load the theme.
  zgen load denysdovhan/spaceship-prompt spaceship

  # generate the init script from plugins above
  zgen save
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000


# Global configs

# Add user bin to path

# Zsh vim mode
bindkey -v
bindkey '^?' backward-delete-char
bindkey '^w' backward-kill-word

# Configure the Prompt
precmd() {
  RPROMPT=""
}

zle-keymap-select() {
  RPROMPT=""
  [[ $KEYMAP = vicmd ]] && RPROMPT="NORMAL"
  () { return $__prompt_status }
  zle reset-prompt
}

zle-line-init() {
  typeset -g __prompt_status="$?"
}

# These attach the above widgets to the zle functions that get called on mode changes
zle -N zle-keymap-select
zle -N zle-line-init
# Reduce the time zsh takes to check for special characters

# Fasd
eval "$(fasd --init auto)"
alias ds="fasd -d | tr -s ' ' | cut -d ' ' -f 2"
unalias z
function z () {
  cd $(ds | fzf)
}

# fzf
# fe (renamed vf) [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
vf() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Things for the shell

# Rust
# Rust source on load
source $HOME/.cargo/env
export RUST_SRC_PATH=~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src

findAlias() {
  alias | grep $1
}
alias fali=findAlias
alias aali="nvim ~/.zshrc"
alias reload="source ~/.zshrc"
alias la="ls -la"

# File System & Navigation {{{
# Make a new directory and cd into it {{{
mkCd() {
  mkdir $1 && cd $1
}
alias mkcd=mkCd
# }}}
# }}}
# Scripts {{{
alias ffws="findFilesWithString"
alias work="bash ~/Scripts/WorkScripts/launch_work_setup.sh"
# }}}

# Things for the web
findPort() {
  lsof -wni tcp:$1
}
alias whereserver=findPort

# Things for Vim
alias v="nvim"
alias vvim="nvim ~/.vimrc"
alias vplugi="nvim +PlugInstall"
# Making ctrl-h work in neovim
#infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > ~/$TERM.ti
#tic ~/$TERM.ti

# Things for git
alias gs="git status"
alias gl="git log --graph --decorate --pretty=oneline"
alias glm="git log --graph --decorate --pretty=oneline --author=Garrett"
alias gaa="git add ."
alias gcan="git commit --amend --no-edit"
alias ghom="git pull origin master"
alias gpoh="git push origin HEAD"
alias gpohf="git push origin HEAD --force"
# Get path of root directory in git repo
alias groot="git rev-parse --show-toplevel"
alias gsquash="bash ~/Code/scripts/squash-commits.sh"

# Things for NPM/Node
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nig="npm install --global"
alias nt="npm test"
alias nit="npm install && npm test"
alias nk="npm link"
alias nr="npm run"
alias nf="npm cache clean && rm -rf node_modules && npm install"
export NODE_OPTIONS='--max-old-space-size=8192' # 8gb
export PATH="/usr/local/Cellar/node/12.6.0/bin:$PATH" 

# Things for Javascripts
alias lb="lerna bootstrap"

# Things for Java

# Thing for tmux
alias ttmux="nvim ~/.tmux.conf"
alias t2="tmux -2"
alias tkill="tmux kill-session"
#source ~/.bin/tmuxinator.zsh # load tmuxinator
alias kernel="tmuxinator start kernel"

# Things for Cassandra
alias localcas="cqlsh 127.0.0.1 --cqlversion=3.1.7"
alias startcas="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.cassandra.plist"
alias stopcas="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.cassandra.plist"

# Things for local machine
alias showhidden="defaults write com.apple.finder AppleShowAllFiles YES"
alias hidehidden="defaults write com.apple.finder AppleShowAllFiles NO"
alias sleep="pmset sleepnow"

# Things for Casa
alias rlc="sh lib/scripts/relink_command.sh"

# Things for Python
alias python="python3"
alias pip="pip3"
if hash pyenv 2>/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

function newEnv() {
  virtualenv .$1 && . .$1/bin/activate
}

alias ne=newEnv # new environment
alias ps="pip install -e ." # python setup
alias pr="pip install -r requirements.txt" # python requirements

# Things for Swift
alias sb="swift build"
alias sbc="swift build --clean"
if hash swiftenv 2>/dev/null; then
  eval "$(swiftenv init -)";
fi

# Kill a process if exists
function killProc() {
  if pgrep $1; then pkill $1; fi
}

# nomouse (send to background)
function nomouse() {
  if pgrep nomouse
  then
    killProc nomouse
    brightness 1
  else
    $HOME/bin/nomouse &
  fi
}

alias nomouse=nomouse

# Misc.
alias google="googler -n5"
alias c="clear"
alias t="trash"
alias uuid="python -c 'import sys,uuid; sys.stdout.write(str(uuid.uuid4()).upper());sys.stdout.write(\"\n\")'"
 
# ruby
eval "$(rbenv init -)"

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /Users/garrettmaring/.npm/_npx/3430/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/garrettmaring/.npm/_npx/3430/lib/node_modules/electron-forge/node_modules/tabtab/.completions/electron-forge.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="/usr/local/opt/openssl/bin:$PATH"

nightlypack() {
  echo "Using nightly toolchain..."
  rustup run nightly $HOME/.cargo/bin/wasm-pack "$@"
}

alias wasm-pack=nightlypack


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Spaceship Theme
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  docker        # Docker section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

# Kitty
alias d="kitty +kitten diff"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
