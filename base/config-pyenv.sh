#!/bin/bash
# install python specific environment files
set -ex

if [ "$EUID" == "0" ]; then
  echo "Do not run this as root, use sudo."
  exit 1
fi

# pyenv packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  python-pip \
  python3-pip \
  make \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  curl \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  python-openssl \
  git \
  && echo "pyenv packages OK!"

# pyenv itself
curl https://pyenv.run | bash

if [ "$(grep -c pyenv "$HOME/.bashrc" )" -eq 0 ]; then
echo "Installing pyenv..."
cat >> "$HOME/.bashrc" << EOF
# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

EOF
echo "Done."

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# install python from .python-version
pyenv install

fi
