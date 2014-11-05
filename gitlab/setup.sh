#!/bin/sh

set -e

[ -e /dev/fs ] || ln -sf /proc/self/fd /dev

yaourt -Sy ca-certificates postgresql-libs python2-docutils gitlab --noconfirm

# disable pam authentication for sshd
sed 's/UsePAM yes/UsePAM no/' -i /etc/ssh/sshd_config
sed 's/UsePrivilegeSeparation yes/UsePrivilegeSeparation no/' -i /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config

cp -vr /build/config/gitlab/* /etc/webapps/gitlab
cp -vr /build/config/gitlab-shell/* /etc/webapps/gitlab-shell
cp -v /build/initrc.d/* /etc/initrc.d

usermod -m -d /data gitlab
passwd -d gitlab


rm -rf /build

pacman -S -cc --noconfirm
rm -rf /var/cache/pacman/pkg
