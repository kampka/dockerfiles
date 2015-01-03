#!/bin/sh
set -e

cat >>/etc/pacman.conf<< EOF
[kampka]
Server = http://pkg.kampka.net
SigLevel = Required
EOF

pacman-key -a /build/pacman.d/kampka.db.key
pacman-key --lsign 10C65A0F
pacman -Sy -qq > /dev/null

pacman -S --noconfirm yaourt pacaur micro-init runit >/dev/null

useradd -M -b /tmp yaourt
echo "yaourt ALL=(ALL) NOPASSWD: /usr/bin/pacman" >> /etc/sudoers.d/yaourt

mkdir -p /etc/initrc.d
cp -vr /build/initrc.d/* /etc/initrc.d/
cp -vr /build/config/* /etc

yaourt -Syu --noconfirm 

[ ! -e /dev/fd ] && ln -s /proc/self/fd /dev

mkdir /services

rm -rf /var/cache/pacman/pkg/*
rm -rf /build

