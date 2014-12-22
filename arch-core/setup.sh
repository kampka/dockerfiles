#!/usr/bin/sh
set -e

pacman -Syu --noconfirm

[ ! -e /dev/fd ] && ln -s /proc/self/fd /dev

rm -rf /var/cache/pacman/pkg/*
rm -rf /build

