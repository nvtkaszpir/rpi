#!/bin/bash
set -ex
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

if [ ! -f "${SCRIPT_DIR}/boot/wpa_supplicant.conf" ]; then
  echo "Missing ${SCRIPT_DIR}/boot/wpa_supplicant.conf"
  echo "Make sure to create it"
  exit 1
fi

sudo cp -f "${SCRIPT_DIR}/boot/wpa_supplicant.conf" /boot/wpa_supplicant.conf

sudo hostnamectl set-hostname hormes

sudo cp -rf "${SCRIPT_DIR}/etc/" /etc/
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive locales
sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure -f noninteractive tzdata

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get remove -y ntp
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  chrony \
  curl \
  dnsmasq \
  dnsutils \
  dstat \
  fping \
  git \
  htp \
  inxi \
  iotop \
  lnav \
  lsb-release \
  mc \
  mtr \
  multitail \
  nano \
  ncdu \
  nmap \
  openssh-server \
  psmisc \
  python-dev \
  python3-dev \
  rfkill \
  rsync \
  rsyslog \
  tmux \
  tree \
  unzip \
  wget \
  xz-utils \
  zip \
  && echo "OK!"

# rpi specific packages
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  python3-gpiozero \
  python3-picamera \
  wiringpi \
  && echo "Rpi packages OK!"


# disable IPv6
sudo cp -f "${SCRIPT_DIR}/etc/sysctl.d/ipv6-disable.conf" /etc/sysctl.d/ipv6-disable.conf

sudo systemctl enable chrony
sudo systemctl start chrony

sudo systemctl enable rsyslog
sudo systemctl start rsyslog

sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq

sudo systemctl enable ssh
sudo systemctl start ssh

# more user friendly message on main screen
sudo cp -f "${SCRIPT_DIR}/etc/issue" /etc/issue

# you never know, lol ;)
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-11-jdk

# fix permissions
sudo chown -R "${UID}:${UID}" "${HOME}"

# fzf
rm -rf "${HOME}/.fzf"
git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}/.fzf"
"${HOME}/.fzf/install" --all --no-zsh --no-fish

# bash-git-prompt
rm -rf "${HOME}/.bash-git-prompt"
git clone --depth=1 https://github.com/magicmonty/bash-git-prompt.git "${HOME}/.bash-git-prompt"

if [ "$(grep -c bash-git-prompt "${HOME}/.bashrc" )" -eq 0 ]; then
echo "Installing bash-git-prompt..."
cat >> "${HOME}/.bashrc" << EOF
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
EOF
echo "Done."
fi
