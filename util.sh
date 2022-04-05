TERMUX=0
if command -v termux-setup-storage &> /dev/null
then
  TERMUX=1
fi

elevation(){
  if [[ $EUID > 0 && $TERMUX != 1 ]]; then
    if ! command -v sudo &> /dev/null
    then
      err "This installer requires sudo for non-root users"
      exit 1
    fi
    sudo "$@"
  else
    "$@"
  fi
}

install_packages(){
  if command -v pacman &> /dev/null
  then
    if [[ $UPDATE != 1 ]]; then
      elevation pacman -Syu
      export UPDATE=1
    fi
    elevation pacman -S "$@" --noconfirm
  fi

  if command -v apt &> /dev/null
  then
    if [[ $UPDATE != 1 ]]; then
      elevation apt update
      export UPDATE=1
    fi
    elevation apt install "$@" -y
  fi
}

err(){
  >&2 echo "E: $*"
}

# from https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}
