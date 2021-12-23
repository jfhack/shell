#!/bin/bash

# BAT_VERSION=v0.18.2

TERMUX=0
if command -v termux-setup-storage &> /dev/null
then
  TERMUX=1

  pkg install bat
  exit
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

install_packages curl wget


# from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

if command -v apt &> /dev/null
then
  if [ -z ${BAT_VERSION+x} ]; then
    BAT_VERSION=$(get_latest_release "sharkdp/bat")
  fi
  echo $BAT_VERSION

  if [ $(uname -m | grep arm | wc -l) -eq 0 ]; then
    if [ $(uname -m | grep aarch64 | wc -l) -eq 0 ]; then
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-musl_${BAT_VERSION:1}_amd64.deb
      elevation apt install ./bat-musl_${BAT_VERSION:1}_amd64.deb
      rm bat-musl_${BAT_VERSION:1}_amd64.deb
    else
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat_${BAT_VERSION:1}_arm64.deb
      elevation apt install ./bat_${BAT_VERSION:1}_arm64.deb
      rm bat_${BAT_VERSION:1}_arm64.deb
    fi
  else
    wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat_${BAT_VERSION:1}_armhf.deb
    elevation apt install ./bat_${BAT_VERSION:1}_armhf.deb
    rm bat_${BAT_VERSION:1}_armhf.deb
  fi
else
  install_packages bat
fi
