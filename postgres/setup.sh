#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm postgresql 

rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
