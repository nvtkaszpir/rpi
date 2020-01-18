#!/bin/bash
set -ex
# disables running rpi as wifi access point, and switches to wifi client
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

export DEBIAN_FRONTEND=noninteractive

# revert to default dhcp client configuration
cp -f /etc/dhcpcd-default.conf /etc/dhcpcd.conf || true

# switch dnsmasq to normal no-dhcp mode
systemctl enable dnsmasq
cp -f /etc/dnsmasq-default.conf /etc/dnsmasq.conf || true

# enable current WiFi
systemctl enable wpa_supplicant.service

# disable hostapd so that rpi is no longer an access point
systemctl unmask hostapd
systemctl disable hostapd

echo "RPI configured as normal wifi client."
echo "You should reboot now."
