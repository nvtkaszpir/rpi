#!/bin/bash
set -ex
# make install in cli mode only

SCRIPT_DIR="$(realpath "$(dirname "$0")")"
export DEBIAN_FRONTEND=noninteractive

# enable booting into cli mode but with user login required
raspi-config nonint do_boot_behaviour B1

echo "You should reboot now."
