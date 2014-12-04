#!/bin/sh
set -e


haveged -w 4096
pacman-key --init
pacman -Rs --noconfirm haveged
pacman-key --populate archlinux
ln -s /usr/share/zoneinfo/UTC /etc/localtime

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

echo "Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

sed -i "s/^CheckSpace/#CheckSpace/g" /etc/pacman.conf

pacman -Syu --noconfirm

[ ! -e /dev/fd ] && ln -s /proc/self/fd /dev

rm -rf /var/cache/pacman/pkg/*
rm -rf /build

