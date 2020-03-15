#!/bin/bash
set -ex

sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl

echo 'deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable' | sudo tee /etc/apt/sources.list.d/docker.list
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-get update

# must use --no-install-recommends because aufs is in recommended and it fails
# to install, yet it is not needed to run containers
sudo apt install --no-install-recommends docker-ce

# add pi user to docker group, remember to relogin
sudo usermod -aG docker pi

# disable docker/containerd by default to save memory

sudo systemctl stop docker
sudo systemctl disable docker

sudo systemctl stop containerd
sudo systemctl disable containerd
