#!/bin/sh

ln -sf /proc/self/fd /dev/fd

yaourt -Sy python2-pip git gunicorn-python2 --noconfirm

ln -sf /usr/bin/gunicorn-python2 /usr/local/bin/gunicorn

cd /opt

git clone https://github.com/dotcloud/docker-registry.git

cd docker-registry

git checkout 0.7.1

pip2 install ./depends/docker-registry-core
pip2 install .

cd

rm -rf /opt/docker-registry
rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
