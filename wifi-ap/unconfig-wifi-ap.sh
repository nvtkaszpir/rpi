#!/bin/bash
set -ex
# disables running rpi as wifi access point, and switches to wifi client

# revert to default dhcp client configuration
sudo cp -f /etc/dhcpcd-default.conf /etc/dhcpcd.conf || true

# switch dnsmasq to normal no-dhcp mode
sudo systemctl enable dnsmasq
sudo cp -f /etc/dnsmasq-default.conf /etc/dnsmasq.conf || true

# enable current WiFi
sudo systemctl enable wpa_supplicant.service

# disable hostapd so that rpi is no longer an access point
sudo systemctl unmask hostapd
sudo systemctl disable hostapd

echo "RPI configured as normal wifi client."
echo "You should reboot now."
