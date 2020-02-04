#!/bin/bash
set -ex
# bluetooth
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  blueman \
  bluetooth \
  bluez \
  bluez-tools \
  pi-bluetooth \
  python-gobject \
  python-gobject-2 \
  && echo "OK!"


#TODO bluetooth xbox controller auto-pair
#connect to the bluetooth device
#BT_DEV=9C:AA:1B:73:B7:2D

# sudo bluetoothctl
## power on
## agent on
## default-agent
## scan on
## pair $BT_DEV
## trust $BT_DEV
## connect $BT_DEV
## quit

#bluetoothctl << EOF
#connect $BT_DEV
#EOF
