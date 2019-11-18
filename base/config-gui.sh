#!/bin/bash
set -ex
# install Xorg and some window manager and other useful apps
# make boot in gui mode with user login requied

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
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
  doublecmd-gtk \
  && echo "OK!"

# fix alsa mixer, the hard way
cp -f \
  "${SCRIPT_DIR}/usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf" \
  /usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf

# enable booting into gui mode but with user login required
raspi-config nonint do_boot_behaviour B3

echo "You should reboot now."
