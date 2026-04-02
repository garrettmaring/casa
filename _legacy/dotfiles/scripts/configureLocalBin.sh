#!/usr/bin/env bash

## Create a ~/bin directory and adds it to PATH

if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
fi

PATH=$PATH:$HOME/bin
