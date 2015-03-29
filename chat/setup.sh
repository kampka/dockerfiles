#!/bin/sh

set -e

[ -e /dev/fs ] || ln -sf /proc/self/fd /dev

pacman -Sy
pacman -Sy --noconfirm znc bitlbee-libpurple libotr

usermod -d /data/znc znc
usermod -d /data/bitlbee bitlbee

cp -rv /build/initrc.d/* /etc/initrc.d
cp -rv /build/services/* /services

cp -rv /build/config/* /etc

rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
