#!/bin/bash

# BAT_VERSION=v0.18.2

source util.sh

if [[ $TERMUX == 1 ]]
then
  pkg install bat
  exit
fi

install_packages curl wget

if [ -z ${BAT_VERSION+x} ]; then
  BAT_VERSION=$(get_latest_release "sharkdp/bat")
fi

if [ "${BAT_VERSION:1}" == $(bat -V 2> /dev/null | awk '{print $2;}') ]; then
  echo "I: bat is already the newest version ($BAT_VERSION)"
  exit
fi

echo $BAT_VERSION

if command -v apt &> /dev/null
then
  case $(uname -m) in
    armv7l | arm)
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat_${BAT_VERSION:1}_armhf.deb
      elevation apt install ./bat_${BAT_VERSION:1}_armhf.deb
      rm bat_${BAT_VERSION:1}_armhf.deb
      ;;

    aarch64)
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat_${BAT_VERSION:1}_arm64.deb
      elevation apt install ./bat_${BAT_VERSION:1}_arm64.deb
      rm bat_${BAT_VERSION:1}_arm64.deb
      ;;

    *)
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat_${BAT_VERSION:1}_amd64.deb
      elevation dpkg -i ./bat_${BAT_VERSION:1}_amd64.deb
      rm bat_${BAT_VERSION:1}_amd64.deb
      ;;
  esac
elif command -v dnf &> /dev/null
then
  case $(uname -m) in
    aarch64)
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-${BAT_VERSION}-aarch64-unknown-linux-gnu.tar.gz -O /tmp/bat.tar.gz
      ;;
    *)
      wget https://github.com/sharkdp/bat/releases/download/$BAT_VERSION/bat-${BAT_VERSION}-x86_64-unknown-linux-musl.tar.gz -O /tmp/bat.tar.gz
      ;;
  esac
  tar -xzf /tmp/bat.tar.gz -C /tmp
  elevation install /tmp/bat-${BAT_VERSION}*/bat /usr/local/bin/bat
  rm -rf /tmp/bat.tar.gz /tmp/bat-${BAT_VERSION}*
else
  install_packages bat
fi
