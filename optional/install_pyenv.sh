#!/bin/bash

# based on https://gist.github.com/entropiae/326611addf6662d1d8fbf5792ab9a770

source ../util.sh

# install required to compile python

if command -v apt &> /dev/null
then
  install_packages --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
else
  install_packages base-devel
fi

PYENV_ROOT="$HOME/.pyenv"
echo -e "\nWhere do you want to install pyenv? (default: $PYENV_ROOT)"
echo -e "This is where your virtualenvs will be stored\n"
read -e -p "pyenv root : " -i "$PYENV_ROOT" PYENV_ROOT

PYENV_ROOT=$(realpath $PYENV_ROOT)
echo -e "Installing pyenv in $PYENV_ROOT\n"

#check if directory exists
if [ ! -d "$PYENV_ROOT" ]
then
  git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT &> /dev/null
else
  echo -e "pyenv already installed in $PYENV_ROOT\n"
fi

echo -e "Configuring pyenv for $PYENV_ROOT\n"

echo "set --export PYENV_ROOT $PYENV_ROOT" > ~/.config/fish/conf.d/pyenv.fish

fish <<'END_FISH'
  set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
END_FISH

grep -qxF '# pyenv init' ~/.config/fish/config.fish || echo -e '\n\n# pyenv init\nif command -v pyenv 1>/dev/null 2>&1\n  pyenv init - | source\nend' >> ~/.config/fish/config.fish

git clone https://github.com/pyenv/pyenv-virtualenv.git $PYENV_ROOT/plugins/pyenv-virtualenv &> /dev/null

echo -e "\n# Enable virtualenv autocomplete\nstatus --is-interactive; and pyenv init - | source\nstatus --is-interactive; and pyenv virtualenv-init - | source\n" >> ~/.config/fish/conf.d/pyenv.fish

read -r -d '' FIX_PROMPT << EOM
OLD = [
  '    if [ -z "\${QUIET}" ]; then\n',
  '      echo "pyenv-virtualenv: prompt changing not working for fish." 1>&2\n',
  '    fi'
]

NEW = "".join([ f"#{i}" for i in OLD ])
OLD = "".join(OLD)

FILE = "${PYENV_ROOT}/plugins/pyenv-virtualenv/bin/pyenv-sh-activate"

with open(FILE, "r") as f:
  text = f.read()

text = text.replace(OLD, NEW)

with open(FILE, "w") as f:
  f.write(text)

EOM

echo "$FIX_PROMPT" | python -

cat << EOF

Done! Reload your terminal

Quick reference:

  # list all available versions
  pyenv install --list
  
  # install a specific version
  pyenv install 3.10.6
  
  # create a virtualenv
  pyenv virtualenv 3.10.6 my_venv
  
  # activate a virtualenv
  pyenv activate my_venv
  
  # deactivate a virtualenv
  pyenv deactivate
  
  # list all virtualenvs
  pyenv versions
  
  # delete a virtualenv
  pyenv uninstall my_venv

Your virtualenvs are located at ${PYENV_ROOT}/versions

EOF
