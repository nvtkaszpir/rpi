#!/bin/bash
set -ex
# bluetooth
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade

apt-get install -y \
  blueman \
  bluetooth \
  bluez \
  bluez-tools \
  pi-bluetooth \
  python-gobject \
  python-gobject-2 \
  && echo "OK!"
