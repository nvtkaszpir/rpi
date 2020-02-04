#!/bin/bash
set -ex
# set up Raspberry Pi as WiFi Access Point with NAT over eth0
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  chrony \
  hostapd \
  dnsmasq \
  dnsutils \
  && echo "OK!"

# chrony is recommended instead of ntp, especially
# on devices which do not have stable power source
sudo systemctl enable chrony
sudo systemctl start chrony

# enable NAT
sudo cp -f "${SCRIPT_DIR}/etc/sysctl.d/ipv4-forward.conf" /etc/sysctl.d/ipv4-forward.conf
sudo iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
sudo iptables-save | sudo tee /etc/iptables.ipv4.nat
sudo cp -f "${SCRIPT_DIR}/etc/rc.local" /etc/rc.local

# set static IP for WiFi card
sudo cp -f /etc/dhcpcd.conf /etc/dhcpcd-default.conf
sudo cp -f "${SCRIPT_DIR}/etc/dhcpcd-ap.conf" /etc/dhcpcd-ap.conf
sudo cp -f /etc/dhcpcd-ap.conf /etc/dhcpcd.conf

# set up dnsmasq as DNS server and DHCP server
sudo systemctl enable dnsmasq
sudo cp -f /etc/dnsmasq.conf /etc/dnsmasq-default.conf
sudo cp -f "${SCRIPT_DIR}/etc/dnsmasq-ap.conf" /etc/dnsmasq-ap.conf
sudo cp -f /etc/dnsmasq-ap.conf /etc/dnsmasq.conf

# disable current WiFi
sudo systemctl disable wpa_supplicant.service

# configure hostapd to change WiFi to Access Point
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl stop hostapd
sudo cp -f "${SCRIPT_DIR}/etc/hostapd/hostapd.conf" /etc/hostapd/hostapd.conf
sudo cp -f "${SCRIPT_DIR}/etc/default/hostapd" /etc/default/hostapd

echo "RPI configured as wifi access-point"
echo "You should reboot now."
