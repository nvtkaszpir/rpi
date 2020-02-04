#!/bin/bash
set -ex
# install Xorg and some window manager and other useful apps
# make boot in gui mode with user login requied

SCRIPT_DIR="$(realpath "$(dirname "$0")")"

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

# LXDE
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  xserver-xorg \
  xinit \
  && echo "OK!"

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  lightdm \
  lxde-core \
  lxappearance \
  && echo "OK!"

# remove screensaver, fallback to blank screen
sudo DEBIAN_FRONTEND=noninteractive apt remove -y xscreensaver

# apps
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  chromium \
  steamlink \
  doublecmd-gtk \
  && echo "OK!"

# fix alsa mixer, the hard way
sudo cp -f \
  "${SCRIPT_DIR}/usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf" \
  /usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf

# enable booting into gui mode but with user login required
sudo raspi-config nonint do_boot_behaviour B3

echo "You should reboot now."
