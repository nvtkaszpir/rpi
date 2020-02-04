# Raspberry Pi 3 B+ config scripts

## About

Make initial config easier without the need of creating full custom image
or to install anything on any other machine.

* base - base config
* donkey - extend base with donkeycar specific settings
* wifi-ap - extend base which will convert rpi into wifi access point,
  with NAT/MASQUERAE over eth0 interface

## Known limitations

* python 3.7.6 and picamera have [issues](https://github.com/waveform80/picamera/issues/604)
* tested with `buster` only
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
* run on device, you will be asked for sudo:

```bash
ssh pi@raspberrypi
mkdir ~/src/
cd ~/src
sudo apt-get update && sudo apt-get install -y git tmux
tmux
git clone http://github.com/nvtkaszpir/rpi
cd rpi
./base/config.sh
./base/config-bt.sh
./base/config-cli.sh

```

Run other customizations scripts if needed.

## Test

run [pre-commit](https://pre-commit.com/) hooks:

```bash
pre-commit run
```

Or go full mental:

```bash
pre-commit run -a
```

## TODO

* check I2C 400, check SPI
* bluetooth xbox controller auto-pair
* notification that install is complete (slack/discord)
* wrapper script for mounted sd-card?
* fetch data for donkey from gh
* rclone
* rewrite with ansible?
