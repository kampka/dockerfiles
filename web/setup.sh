#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm nginx
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/sites.d

cp -rv /build/initrc.d /etc
cp -rv /build/config/nginx /etc
cp -v /build/bin/logger /usr/local/bin/logger

useradd -M --system -d /data/www www-data

rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
