#!/bin/sh
set -e

ln -sf /proc/self/fd /dev

pacman -Sy redis --noconfirm

sed -i 's/^\(bind .*\)$/# \1/' /etc/redis.conf
sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/storage/' /etc/redis.conf
sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis.conf

echo "include /data/redis.conf" >> /etc/redis.conf

rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
