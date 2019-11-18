#!/bin/bash
set -ex
export DEBIAN_FRONTEND=noninteractive


# increase swap
systemctl stop dphys-swapfile
cp -f etc/dphys-swapfile /etc/dphys-swapfile
systemctl start dphys-swapfile
