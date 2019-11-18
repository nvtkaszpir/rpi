# Raspberry Pi 3 B+ config scripts

## About

Make initial config easier without the need of creating full custom image
or to install anything on any other machine.

* base - base config
* donkey - extend base with donkeycar specific settings
* wifi-ap - extend base which will convert rpi into wifi access point,
  with NAT/MASQUERAE over eth0 interface

## Known limitations

* use at least 32GB sdcard
* tested with `buster` only
* wifi-ap was not fully tested, just wrote it from memory but should work
* anything else ¯\_(ツ)_/¯

## Installation

* Use [balena echer](https://www.balena.io/etcher/) to write image.
* use `base` directory as base customizations, depending on sd-card
* (optional) add `base/boot/wpa_supplicant.conf` with wifi config
* write `boot/` directly (skip chown)
* (optional) write `home/` and `chown -R 1000:1000 /home/pi`
* Use other dirs for additional tuning
* unmount sd-card, install in device, boot device
* (in case of wifi-ap) connect to the device via ethernet cable
* run on device:

```bash
ssh pi@raspberrypi
mkdir ~/src/
cd ~/src
sudo apt-get update && sudo apt-get install -y git tmux
tmux
git clone http://github.com/nvtkaszpir/rpi
cd rpi
sudo ./base/config.sh

```

Run other customizations scripts if needed.

## TODO

* notification that install is complete (slack/discord)
* test wifi-ap
* wrapper script for mounted sd-card?
* fetch data for donkey from gh
* rclone
* rewrite with ansible?
