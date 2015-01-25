#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm --needed postgresql postgresql-old-upgrade grep

mkdir -p /data

mkdir -p /etc/initrc.d
cp -v /build/initrc.d/* /etc/initrc.d

mkdir -p /services
cp -rv /build/services/* /services

rm -rf /build

REMOVABLES=$(pacman -Qqtd) || true

if [ -n "$REMOVABLES" ]; then
   pacman -Rns --noconfirm $REMOVABLES
fi
pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
