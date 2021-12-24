#!/bin/bash

TERMUX=0
if command -v termux-setup-storage &> /dev/null
then
  TERMUX=1
fi

elevation(){
  if [[ $EUID > 0 && $TERMUX == 0 ]]; then
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
if [[ $TERMUX == 1 ]]; then
  chsh -s fish
else
  chsh -s $(which fish)
fi
mkdir -p ~/.config/fish/functions
cp fish/config.fish ~/.config/fish/config.fish
cp fish/fish_title.fish ~/.config/fish/functions/fish_title.fish
cp fish/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
fish fish/configure.fish

bash install_only_exa.sh
bash install_only_bat.sh