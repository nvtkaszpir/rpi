#!/bin/bash
set -ex
# install Xorg and some window manager and other useful apps
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade

# LXDE
apt-get install -y --no-install-recommends \
  xserver-xorg \
  xinit \
  && echo "OK!"

apt-get install -y \
  lightdm \
  lxde-core \
  lxappearance \
  && echo "OK!"

# remove screensaver, fallback to blank screen
apt remove -y xscreensaver

# apps
apt install -y \
  chromium \
  steamlink \
  doublecmd \
  && echo "OK!"

echo "You should reboot now."
