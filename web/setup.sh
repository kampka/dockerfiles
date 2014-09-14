#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm nginx
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/sites.d

cp -v /build/nginx.conf /etc/nginx

useradd -M --system -d /data/www www-data

rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
