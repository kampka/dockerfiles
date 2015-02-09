#!/bin/sh

set -e

ln -sf /proc/self/fd /dev

pacman -Sy --noconfirm --asdeps --needed base-devel
sudo -u yaourt yaourt -Sy --noconfirm owncloud php-intl php-mcrypt php-pgsql php-xcache exiv2 php-fpm dcron ca-certificates

mkdir -p /data/config
#ln -sf /data/config /usr/share/webapps/owncloud

cp -rv /build/config/nginx /etc
cp -rv /build/config/php /etc
cp -rv /build/config/owncloud/* /etc/webapps/owncloud/config
cp -rv /build/config/cron/* /etc/cron.d

cp -v /build/src/errorlog.php /usr/share/webapps/owncloud/lib/private/log

mkdir -p /etc/initrc.d
cp -v /build/initrc.d/* /etc/initrc.d

mkdir -p /services
cp -rv /build/services/* /services

rm -rf /build

pacman -Rns --noconfirm $(pacman -Qqtd)
pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
