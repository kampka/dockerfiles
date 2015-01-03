#!/bin/sh
set -e

ln -sf /proc/self/fd /dev

pacman -Sy tar --noconfirm
sudo -u yaourt yaourt -Sy base-devel --noconfirm --needed --asdeps
sudo -u yaourt yaourt -Sy python2-pip git --noconfirm
cd /tmp

git clone https://github.com/dotcloud/docker-registry.git

cd docker-registry

git checkout 0.8.1

pip2 install ./depends/docker-registry-core
pip2 install .

cd

cp /build/config/config.yml /etc

rm -rf /tmp/docker-registry
rm -rf /build

pacman -Rns --noconfirm $(pacman -Qqtd)
pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
