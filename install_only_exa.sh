#!/bin/bash

# EXA_VERSION=v0.10.1

TERMUX=0
if command -v termux-setup-storage &> /dev/null
then
  TERMUX=1

  pkg install exa
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

if [ "$EXA_VERSION" == $(exa -v 2> /dev/null | sed -n 2p | awk '{print $1;}') ]; then
  echo "exa is already the newest version ($EXA_VERSION)"
  exit
fi

echo $EXA_VERSION

PATH=$PATH:~/.cargo/bin/

case $(uname -m) in
  armv7l | arm)
    wget https://github.com/ogham/exa/releases/download/$EXA_VERSION/exa-linux-armv7-$EXA_VERSION.zip
    elevation unzip -o exa-linux-armv7-$EXA_VERSION.zip -d /usr/local
    rm exa-linux-armv7-$EXA_VERSION.zip
    ;;

  aarch64)
    install_packages gcc
    echo "installing exa with cargo"
    if [ ! -n "$(command -v cargo)" ]; then
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
      echo "rust installed"
    fi
    git clone https://github.com/ogham/exa.git
    cd exa
    cargo build --release
    elevation cp target/release/exa /usr/local/bin/
    RETVAL=$?
    rm -rf exa
    if [ $RETVAL -ne 0 ]; then
      install_packages exa
    fi
    ;;

  *)
    wget https://github.com/ogham/exa/releases/download/$EXA_VERSION/exa-linux-x86_64-musl-$EXA_VERSION.zip
    elevation unzip -o exa-linux-x86_64-musl-$EXA_VERSION.zip -d /usr/local
    rm exa-linux-x86_64-musl-$EXA_VERSION.zip
    ;;
esac
