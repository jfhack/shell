#!/bin/bash

elevation(){
  if [[ $EUID > 0 ]]; then
    sudo "$@"
  else
    "$@"
  fi
}

install_packages(){
  if command -v pacman &> /dev/null
  then
    elevation pacman -Syu
    elevation pacman -S "$@" --noconfirm
  fi

  if command -v apt &> /dev/null
  then
    elevation apt update
    elevation apt install "$@" -y
  fi
}

install_packages git fish

chsh -s $(which fish)
mkdir -p ~/.config/fish/functions
cp fish/config.fish ~/.config/fish/config.fish
cp fish/fish_title.fish ~/.config/fish/functions/fish_title.fish
cp fish/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
fish fish/configure.fish

bash install_only_exa.sh
bash install_only_bat.sh