# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
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

# open workbench config, must play music twerk music, hard rap, or on rare occasionals soulful r&b for the anti-mood
alias twerk="cd $CASA_CONFIG && edit $CASA_CONFIG/README.md"

# editor
alias v="$EDITOR"
alias edit="$EDITOR"
alias vim="$EDITOR"
alias nvim="$EDITOR"
alias nano="$EDITOR"

# symbolic links (ln)
alias lns="ln -s"
alias la="ls -la"

# git
alias gco="git checkout"
alias gs="git status"
alias gd="git diff"

# ai git helpers
aigcm() {
    typeset staged_diff
    typeset unstaged_diff
    typeset diff
    typeset prompt
    typeset message
    
    staged_diff=$(git diff --cached --unified=3)
    unstaged_diff=$(git diff --unified=3)
    
    if [ -n "$staged_diff" ]; then
        diff=$staged_diff
    elif [ -n "$unstaged_diff" ]; then
        diff=$unstaged_diff
    else
        echo "No changes detected. Stage or make some changes first."
        return 1
    fi
    
    prompt="Generate a git commit message for this diff. Rules: 1) Use present tense 2) Be concise - max 50 chars 3) Start with a verb 4) No quotes or explanations 5) No Markdown 6) No prefixes or ticket numbers:\n\n$diff"
    
    message=$(echo "$prompt" | ollama run llama2:latest | head -n 1 | tr -d '"' | tr -d "'" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "gc -m '$message'"
}

aiwf() {
    typeset diff
    typeset prompt
    
    diff=$(git diff)
    if [ -z "$diff" ]; then
        echo "No changes detected."
        return 1
    fi
    
    prompt="Review this diff and identify potential issues, bugs, or problematic patterns. Focus on security, performance, and best practices. Be direct and specific:\n\n$diff"
    
    echo "Analyzing changes...\n"
    echo "$prompt" | ollama run llama2:latest
}
alias gl="git log --graph --decorate --pretty=oneline"
alias gaa="git add ."
alias gc="git commit -S"
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
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nd="npm run dev"
alias ns="npm run start"
alias nb="npm run build"
alias nt="npm run test"
alias np="npm run pretty"

# pnpm
alias pi="pnpm install"
alias pis="pnpm install --save"
alias pid="pnpm install --save-dev"
alias pd="pnpm run dev"
alias ps="pnpm run start"
alias pb="pnpm run build"
alias pt="pnpm run test"
alias pp="pnpm run pretty"

# file navigation
alias ..="cd .."

# configure prompt with starship
eval "$(starship init zsh)"

# openai
alias oafr="openai api fine_tunes.results -i $1"

# ai
alias codecopy='for f in "$@"; do echo -e "\n# $f\n"; cat "$f"; done | pbcopy' # codecopy is useful to get all contents to paste into chat (codecopy file1.js file2.py file3.txt)

# ruby
eval "$(rbenv init -)"

# python
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
alias python="python3"
alias pip="pip3"

# engi
alias engi="pipenv run engi "
alias eengi="cd $ENGI_MONOREPO_DIR && edit $ENGI_MONOREPO_DIR/README.md" # edit engi
alias ee=eengi
alias gengi="cd $ENGI_MONOREPO_DIR" # go engi
alias ge=gengi

# misc.
alias sand="cd $SANDBOX_HOME"

export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"

#alias engienv="source /Users/g/.local/share/virtualenvs/cli-L_QUJPw1/bin/activate"
#alias engi="PIPENV_VERBOSITY=-1 pipenv run engi"

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


#[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
