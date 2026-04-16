# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# load zsh plugin manager zgen
[[ -f "${HOME}/.zgen/zgen.zsh" ]] && source "${HOME}/.zgen/zgen.zsh"

# init zgen if needed
if command -v zgen >/dev/null 2>&1 && ! zgen saved; then

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
if command -v kitty >/dev/null 2>&1 && [ -f "$CONFIG_HOME/.base16_theme" ]; then
  theme_file="$CONFIG_HOME/kitty/colors/$(cat "$CONFIG_HOME/.base16_theme").conf"
  [ -f "$theme_file" ] && kitty @ set-colors --all --configured -c "$theme_file" 2>/dev/null
fi
# set kitty tab/window name to directory automagically (https://github.com/kovidgoyal/kitty/issues/930)
precmd () {print -Pn "\e]0;%~\a"}

# open workbench config, must play music twerk music, hard rap, or on rare occasionals soulful r&b for the anti-mood
alias twerk="cd $CASA_CONFIG && edit $CASA_CONFIG/README.md"

# editor
alias v="$EDITOR"
alias edit="$EDITOR"
alias ai="$AI"
alias vim="$EDITOR"
alias nvim="$EDITOR"
alias nano="$EDITOR"

# symbolic links (ln)
alias lns="ln -s"
alias la="ls -la"

# git
git_default_diff_range() {
  local remote_head
  remote_head="$(git symbolic-ref --quiet refs/remotes/origin/HEAD 2>/dev/null)"

  if [[ -n "$remote_head" ]]; then
    printf '%s\n' "origin/${remote_head#refs/remotes/origin/}...HEAD"
    return 0
  fi

  local ref
  for ref in origin/main origin/master main master; do
    if git rev-parse --verify "$ref" >/dev/null 2>&1; then
      printf '%s\n' "$ref...HEAD"
      return 0
    fi
  done

  printf '%s\n' 'HEAD~1...HEAD'
}

git_diffview() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "git_diffview: not inside a git repository" >&2
    return 1
  fi

  local ex_cmd
  local -a editor_args
  local -a remote_args
  local data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  local diffview_start="$data_home/nvim/site/pack/packer/start/diffview.nvim"
  local diffview_opt="$data_home/nvim/site/pack/packer/opt/diffview.nvim"
  local use_remote=0
  local has_diffview=0

  if command -v nvr >/dev/null 2>&1 && { [[ -n "${NVIM:-}" ]] || [[ -n "${NVIM_LISTEN_ADDRESS:-}" ]]; }; then
    use_remote=1
  fi

  if [[ -d "$diffview_start" || -d "$diffview_opt" ]]; then
    has_diffview=1
  fi

  if (( ! has_diffview )); then
    case "${1:-}" in
      "" )
        git diff
        return
        ;;
      index|current|--index|-i)
        shift
        git diff "$@"
        return
        ;;
      default-branch|branch|ahead|remote|origin|--default-branch|-b)
        shift
        git diff "$(git_default_diff_range)" "$@"
        return
        ;;
      working-tree|worktree|wt|--working-tree|-w)
        shift
        git diff "$@"
        return
        ;;
      file|--file|-f)
        shift
        if (( $# == 0 )); then
          echo "git_diffview file: pass a file path when Diffview is unavailable" >&2
          return 1
        fi
        git log --follow -- "$1"
        return
        ;;
      history|repo|--history)
        shift
        git log --graph --decorate --oneline --all "$@"
        return
        ;;
      close|quit|q|--close)
        return 0
        ;;
      --help|-h)
        ;;
      *)
        git diff "$@"
        return
        ;;
    esac
  fi

  case "${1:-}" in
    "" )
      ex_cmd="GitDiff"
      ;;
    index|current|--index|-i)
      shift
      ex_cmd="GitDiffIndex"
      ;;
    default-branch|branch|ahead|remote|origin|--default-branch|-b)
      shift
      ex_cmd="GitDiffDefaultBranch"
      ;;
    working-tree|worktree|wt|--working-tree|-w)
      shift
      ex_cmd="GitDiffWorkingTree"
      ;;
    file|--file|-f)
      shift

      if (( $# > 0 )); then
        editor_args+=("$1")
        remote_args+=("$1")
        shift
      elif (( ! use_remote )); then
        echo "git_diffview file: pass a file path when launching from the shell" >&2
        return 1
      fi

      ex_cmd="GitDiffFileHistory"
      ;;
    history|repo|--history)
      shift
      ex_cmd="GitDiffHistory"
      ;;
    close|quit|q|--close)
      shift
      ex_cmd="GitDiffClose"
      ;;
    --help|-h)
      cat <<'EOF'
git_diffview
git_diffview index
git_diffview default-branch
git_diffview [revision-range]
git_diffview working-tree
git_diffview file <path>
git_diffview history
git_diffview close
EOF
      return 0
      ;;
    *)
      ex_cmd="GitDiff $*"
      ;;
  esac

  if (( use_remote )); then
    nvr "${remote_args[@]}" -cc "$ex_cmd"
  else
    nvim "${editor_args[@]}" "+$ex_cmd"
  fi
}

alias gco="git checkout"
alias gs="git status"
alias gd="git_diffview"
alias gdd="git diff"
alias gdi="git_diffview index"
alias gdb="git_diffview default-branch"
alias gdw="git_diffview working-tree"
alias gdf="git_diffview file"
alias gdh="git_diffview history"
alias gdq="git_diffview close"

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
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# openai
alias oafr="openai api fine_tunes.results -i $1"

# ai
alias codecopy='for f in "$@"; do echo -e "\n# $f\n"; cat "$f"; done | pbcopy' # codecopy is useful to get all contents to paste into chat (codecopy file1.js file2.py file3.txt)

# ruby
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# python
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  command -v pyenv-virtualenv-init >/dev/null 2>&1 && eval "$(pyenv virtualenv-init -)"
fi
alias python="python3"
alias pip="pip3"

# engi
alias engi="pipenv run engi "
alias eengi="cd $ENGI_MONOREPO_DIR && edit $ENGI_MONOREPO_DIR/internal-docs/README.md" # edit engi
alias ee=eengi
alias gengi="cd $ENGI_MONOREPO_DIR" # go engi
alias ge=gengi
alias aiengi="cd $ENGI_MONOREPO_DIR && ai" # ai develop engi
alias ae=aiengi

# misc.
alias sand="cd $SANDBOX_HOME"

export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"

#alias engienv="source /Users/g/.local/share/virtualenvs/cli-L_QUJPw1/bin/activate"
#alias engi="PIPENV_VERBOSITY=-1 pipenv run engi"

# https://igor.moomers.org/navigating-arch-on-osx
alias brow='arch --x86_64 /usr/local/homebrew/bin/brew'


# >>> conda initialize >>>
# !! Contents within this block are managed by Casa bootstrap expectations. !!
if [ -x "$CONDA_HOME/bin/conda" ]; then
  __conda_setup="$("$CONDA_HOME/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  elif [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
    . "$CONDA_HOME/etc/profile.d/conda.sh"
  else
    export PATH="$CONDA_HOME/bin:$PATH"
  fi
  unset __conda_setup
fi
# <<< conda initialize <<<


#[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

# OpenClaw Completion
source "/Users/garrettmaring/.openclaw/completions/openclaw.zsh"
