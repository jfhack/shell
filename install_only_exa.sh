#!/bin/bash

# EXA_VERSION=v0.10.1

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

install_packages curl git wget unzip

# from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

if [ -z ${EXA_VERSION+x} ]; then
  EXA_VERSION=$(get_latest_release "ogham/exa")
fi
echo $EXA_VERSION

PATH=$PATH:~/.cargo/bin/
if [ $(uname -m | grep arm | wc -l) -eq 0 ]; then
  if [ $(uname -m | grep aarch64 | wc -l) -eq 0 ]; then
    wget https://github.com/ogham/exa/releases/download/$EXA_VERSION/exa-linux-x86_64-musl-$EXA_VERSION.zip
    elevation unzip -o exa-linux-x86_64-musl-$EXA_VERSION.zip -d /usr/local
    rm exa-linux-x86_64-musl-$EXA_VERSION.zip
  else
    echo "installing exa with cargo"
    if [ ! -n "$(command -v cargo)" ]; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      echo "rust installed"
    fi
    git clone https://github.com/ogham/exa.git
    cd exa
    cargo build --release
    elevation cp target/release/exa /usr/local/bin/
  fi
else
  wget https://github.com/ogham/exa/releases/download/$EXA_VERSION/exa-linux-armv7-$EXA_VERSION.zip
  elevation unzip -o exa-linux-armv7-$EXA_VERSION.zip -d /usr/local
  rm exa-linux-armv7-$EXA_VERSION.zip
fi