#!/bin/bash
set -ex
# set up Raspberry Pi as WiFi Access Point with NAT over eth0
SCRIPT_DIR="$(realpath "$(dirname "$0")")"

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y dist-upgrade

apt-get install -y \
  chrony \
  hostapd \
  dnsmasq \
  dnsutils \
  && echo "OK!"

# chrony is recommended instead of ntp, especially 
# on devices which do not have stable power source
systemctl enable chrony
systemctl start chrony

# enable NAT
cp -f "${SCRIPT_DIR}/etc/sysctl.d/ipv4-forward.conf" /etc/sysctl.d/ipv4-forward.conf
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
iptables-save > /etc/iptables.ipv4.nat
cp -f "${SCRIPT_DIR}/etc/rc.local" /etc/rc.local

# set static IP for WiFi card
cp -f /etc/dhcpcd.conf /etc/dhcpcd-default.conf
cp -f "${SCRIPT_DIR}/etc/dhcpcd-ap.conf" /etc/dhcpcd-ap.conf
cp -f /etc/dhcpcd-ap.conf /etc/dhcpcd.conf

# set up dnsmasq as DNS server and DHCP server
systemctl enable dnsmasq
cp -f /etc/dnsmasq.conf /etc/dnsmasq-default.conf
cp -f "${SCRIPT_DIR}/etc/dnsmasq-ap.conf" /etc/dnsmasq-ap.conf
cp -f /etc/dnsmasq-ap.conf /etc/dnsmasq.conf

# disable current WiFi
systemctl disable wpa_supplicant.service

# configure hostapd to change WiFi to Access Point
systemctl unmask hostapd
systemctl enable hostapd
systemctl stop hostapd
cp -f "${SCRIPT_DIR}/etc/hostapd/hostapd.conf" /etc/hostapd/hostapd.conf
cp -f "${SCRIPT_DIR}/etc/default/hostapd" /etc/default/hostapd

echo "RPI configured as wifi access-point"
echo "You should reboot now."
