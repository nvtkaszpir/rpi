#!/bin/bash
set -ex
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

export DEBIAN_FRONTEND=noninteractive


# increase swap
systemctl stop dphys-swapfile
cp -f "${SCRIPT_DIR}/etc/dphys-swapfile" /etc/dphys-swapfile
systemctl start dphys-swapfile
