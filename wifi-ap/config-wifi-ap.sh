#!/bin/bash
set -ex
# set up Raspberry Pi as WiFi Access Point with NAT over eth0

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
cp -f etc/sysctl.d/ipv4-forward.conf /etc/sysctl.d/ipv4-forward.conf
iptables -t nat -A  POSTROUTING -o eth0 -j MASQUERADE
iptables-save > /etc/iptables/iptables.ipv4.nat
cp -f etc/rc.local /etc/rc.local

# set static IP for WiFi card
cp -f etc/dhcpcd.conf /etc/dhcpcd.conf

# set up dnsmasq as DNS server and DHCP server
systemctl enable dnsmasq
systemctl stop dnsmasq
cp -f etc/dnsmasq.conf /etc/dnsmasq.conf

# disable current WiFi
systemctl stop wpa_supplicant.service
systemctl disable wpa_supplicant.service

# configure hostapd to change WiFi to Access Point
systemctl unmask hostapd
systemctl enable hostapd
systemctl stop hostapd
cp -f etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf
cp -f etc/default/hostapd /etc/default/hostapd

echo "You should reboot now."
