#!/bin/bash

source util.sh

if [[ $TERMUX == 1 ]]
then
  pkg install eza
  exit
fi

install_packages curl wget

if [ -z ${EZA_VERSION+x} ]; then
  EZA_VERSION=$(get_latest_release "eza-community/eza")
fi

if [ "$EZA_VERSION" == $(eza --version 2> /dev/null | head -1 | awk '{print $2;}') ]; then
  echo "I: eza is already the newest version ($EZA_VERSION)"
  exit
fi

echo "Installing eza $EZA_VERSION"

case $(uname -m) in
  armv7l | arm)
    ARCH="arm-unknown-linux-gnueabihf"
    ;;

  aarch64)
    ARCH="aarch64-unknown-linux-gnu"
    ;;

  *)
    ARCH="x86_64-unknown-linux-musl"
    ;;
esac

TMPDIR=$(mktemp -d)
wget -q "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_${ARCH}.tar.gz" -O "$TMPDIR/eza.tar.gz"
tar -xzf "$TMPDIR/eza.tar.gz" -C "$TMPDIR"
elevation install "$TMPDIR/eza" /usr/local/bin/eza
rm -rf "$TMPDIR"
