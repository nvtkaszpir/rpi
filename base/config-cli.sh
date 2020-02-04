#!/bin/bash
set -ex
# make install in cli mode only

# enable booting into cli mode but with user login required
sudo raspi-config nonint do_boot_behaviour B1

echo "You should reboot now."
