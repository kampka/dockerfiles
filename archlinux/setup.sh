#!/bin/sh
set -e

sed -i "s/^CheckSpace/#CheckSpace/g" /etc/pacman.conf
cat >>/etc/pacman.conf<< EOF
[kampka]
Server = http://pkg.kampka.net
SigLevel = Required
EOF

pacman-key -a /build/pacman.d/kampka.db.key
pacman-key --lsign 10C65A0F
pacman -Sy -qq > /dev/null
pacman -S --noconfirm base-devel >/dev/null

pacman -S --noconfirm yaourt pacaur micro-init runit >/dev/null

mkdir -p /etc/initrc.d
cp -v /build/initrc.d/* /etc/initrc.d/

yaourt -Syu --noconfirm 

ln -s /proc/self/fd /dev

mkdir /services

rm -rf /var/cache/pacman/pkg/*
rm -rf /build

