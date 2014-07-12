#!/bin/sh

ln -sf /proc/self/fd /dev

yaourt -Sy python2-pip git --noconfirm
cd /tmp

git clone https://github.com/dotcloud/docker-registry.git

cd docker-registry

git checkout 0.7.3

pip2 install ./depends/docker-registry-core
pip2 install .

cd

rm -rf /tmp/docker-registry
rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
