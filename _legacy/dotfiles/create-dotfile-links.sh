#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$DIR"
for f in $(find $DIR -maxdepth 1 -type f -exec basename {} \;| grep -v "(\.git)" | grep "^\..*") 
do
  echo "Linking ~/$f"
  rm ~/$f
  ln -s $DIR/$f ~/$f
done

mkdir -p $HOME/.config
ln -s ~/.vim $HOME/.config/nvim
ln -s ~/.vimrc $HOME/.config/nvim/init.vim
