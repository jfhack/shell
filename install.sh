#!/bin/bash

export UPDATE=0

source util.sh

install_packages git fish curl

if [[ "$(basename $SHELL)" == "fish" || ! -z "$ALREADY_USING_FISH" ]]; then
  echo "I: already using fish"
else
  if [[ $TERMUX == 1 ]]; then
    chsh -s fish
  else
    if [[ $EUID > 0 ]]; then
      echo "I: password might be required by: chsh -s $(which fish)"
    fi
    chsh -s $(which fish)
  fi
fi

mkdir -p ~/.config/fish/functions
cp fish/config.fish ~/.config/fish/config.fish
cp fish/fish_title.fish ~/.config/fish/functions/fish_title.fish
cp fish/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
fish fish/configure.fish

bash install_only_exa.sh
bash install_only_bat.sh