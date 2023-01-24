# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# load zsh plugin manager zgen
source "${HOME}/.zgen/zgen.zsh"

# init zgen if needed
if ! zgen saved; then

  # specify plugins here

  # generate the init script from plugins above
  zgen save
fi

# fuzzy find and go (cd) to it
function fuzzy_find_file_cd() {
  local file

  file="$(fzf)"

  # if selecting a file instead of a directory, go to its parent
  if [[ -n $file ]]
  then
     if [[ -d $file ]]
     then
        cd -- $file
     else
        cd -- ${file:h}
     fi
  fi
}
alias g=fuzzy_find_file_cd

# fuzzy find and vim to it
function fuzzy_find_file_edit() {
  $EDITOR $(fzf)
}
alias f=fuzzy_find_file_edit

# make a directory and cd into it
function make_dir_cd() {
  mkdir $1 && cd $1
}
alias mkcd=make_dir_cd

# terminal (kitty) color theme
eval "kitty @ set-colors --all --configured -c $CONFIG_HOME/kitty/colors/$(cat $CONFIG_HOME/.base16_theme).conf"
# set kitty tab/window name to directory automagically (https://github.com/kovidgoyal/kitty/issues/930)
precmd () {print -Pn "\e]0;%~\a"}

# configuration files (casa)
alias casa="edit $CASA_CONFIG/README.md"
alias casa-tmux="edit $CASA_CONFIG/.config/.tmux.conf"

# vim
alias v="$EDITOR"
alias edit="$EDITOR"

# symbolic links (ln)
alias lns="ln -s"
alias la="ls -la"

# git
alias gco="git checkout"
alias gs="git status"
alias gd="git diff"
alias gl="git log --graph --decorate --pretty=oneline"
alias gaa="git add ."
alias gc="git commit"
alias gcan="git commit --amend --no-edit"
alias gpl="git pull origin"
alias gplo="git pull origin"
alias gpoh="git push origin HEAD"
alias gpohf="git push origin HEAD --force"
alias gsta="git stash -u"
alias gstap="git stash apply"

# shell
alias zreloadprof="source ~/.zshrc"
alias zreloadenv="source ~/.zshenv"
alias reload="zreloadenv && zreloadprof"

# special directories
alias cddeveloper="cd ~/Developer"
alias cdsandbox="cd ~/Developer/Sandbox"

# rust & cargo
alias cbr="cargo build --release"
alias ct="cargo test"

# system info
alias sys="neofetch"

# npm
alias ni="npm install"
alias nd="npm run dev"
alias ns="npm run start"
alias nb="npm run build"

# file navigation
alias ..="cd .."

# configure prompt with starship
eval "$(starship init zsh)"

# openai
alias oafr="openai api fine_tunes.results -i $1"

# ruby
eval "$(rbenv init -)"

# python
eval "$(pyenv init -)"

# misc.
alias sand="cd $SANDBOX_HOME"

export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"

alias engi="pipenv run engi"

# https://igor.moomers.org/navigating-arch-on-osx
alias brow='arch --x86_64 /usr/local/homebrew/bin/brew'


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/g/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/g/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/g/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/g/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
