#!/bin/bash
# disable onboard bluetooth device on rpi, but keep other services
# useful if you have an usb dongle attached to rpi
set -ex

echo 'dtoverlay=pi3-disable-bt' | sudo tee -a /boot/config.txt
echo 'Please reboot now.'
