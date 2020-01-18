#!/bin/bash
set -ex
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

if [ ! -f "${SCRIPT_DIR}/boot/wpa_supplicant.conf" ]; then
  echo "Missing ${SCRIPT_DIR}/boot/wpa_supplicant.conf"
  echo "Make sure to create it"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

hostnamectl set-hostname hormes

cp -rf "${SCRIPT_DIR}/etc/" /etc/
dpkg-reconfigure -f noninteractive locales
dpkg-reconfigure -f noninteractive tzdata

apt-get update
apt-get -y dist-upgrade
apt-get remove -y ntp
apt-get install -y \
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
  sysstat \
  tmux \
  tree \
  unzip \
  wget \
  xz-utils \
  zip \
  && echo "OK!"

# rpi specific packages
apt-get install -y \
  python3-gpiozero \
  python3-picamera \
  wiringpi \
  && echo "Rpi packages OK!"

# disable IPv6
cp -f "${SCRIPT_DIR}/etc/sysctl.d/ipv6-disable.conf" /etc/sysctl.d/ipv6-disable.conf

systemctl enable chrony
systemctl start chrony

systemctl enable rsyslog
systemctl start rsyslog

systemctl enable dnsmasq
systemctl start dnsmasq

systemctl enable ssh
systemctl start ssh

# more user friendly message on main screen
cp -f "${SCRIPT_DIR}/etc/issue" /etc/issue

# you never know, lol ;)
apt-get install -y openjdk-11-jdk

# pi
chown -R 1000:1000 /home/pi

# fzf
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-zsh --no-fish

# bash-git-prompt
rm -rf ~/.bash-git-prompt
git clone --depth=1 https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt

if [ "$(grep -c bash-git-prompt ~/.bashrc )" -eq 0 ]; then
echo "Installing bash-git-prompt..."
cat >> ~/.bashrc << EOF
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
EOF
echo "Done."
fi
