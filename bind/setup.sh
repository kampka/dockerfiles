#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm bind

mkdir -p /data/bind/

useradd --system -U -m -d /var/named named
chown -R root:named /data/bind


rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
