#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

yaourt -Sy --noconfirm bind

mkdir -p /data/bind/
chown -R root:named /data/bind


rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
