# echo "\e[1;36mPreparing: Setting global variables and configure executable visability..."

function append_to_path () {
  export PATH="$PATH:$1"
}

# shell
export PS1="[%* - %D] %d %% "
export KEYTIMEOUT=1

# core
export EDITOR=nvim
export MYVIMRC="$HOME/.vimrc"
append_to_path "$HOME/bin" 
append_to_path "/usr/local/bin" 

# global
export OPENSSL_INCLUDE_DIR=`brew --prefix openssl`/include
export OPENSSL_LIB_DIR=`brew --prefix openssl`/lib
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
append_to_path "/usr/local/opt/openssl/bin" 

# npm
append_to_path "/usr/local/share/npm/bin" 

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
append_to_path "$PYENV_ROOT/bin" 
# https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654
if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# rust
export RUST_SRC_PATH="/usr/local/src/rust/src"
append_to_path ".cargo/bin" 
append_to_path "/usr/local/src/racer/target/release" 

# javascript
append_to_path "`yarn global bin`" 

# java
export JAVA_HOME="$(/usr/libexec/java_home)"

# swift
export SWIFTENV_ROOT="$HOME/.swiftenv"
append_to_path "$SWIFTENV_ROOT/bin" 

# ruby
append_to_path "/.rvm/bin"

# local-only credential if still needed by the legacy setup
export NPM_TOKEN="${NPM_TOKEN:-}"

# END #
# resources
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
#

# https://github.com/python-pillow/Pillow/issues/4816
export LDFLAGS="-L/usr/local/opt/zlib/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include"
export PKG_CONFIG_PATH="/usr/local/opt/zlib/lib/pkgconfig"
