#!/bin/sh

sed -i "s/^CheckSpace/#CheckSpace/g" /etc/pacman.conf
pacman -Sy -qq > /dev/null
pacman -S base-devel --noconfirm > /dev/null
pacman -S clang vim --noconfirm > /dev/null

# Compile the init entrypoint
clang -w -o /usr/local/bin/init /build/src/init.c

mkdir -p /etc/initrc.d
cp -v /build/initrc.d/* /etc/initrc.d/


BUILDDIR=$(mktemp -d)
cd $BUILDDIR
for f in /build/aur/*; do
	makepkg --asroot -c -f -s -i --noconfirm -p $f > /dev/null
done

cd
rm -rf $BUILDDIR

ln -s /proc/self/fd /dev/fd

yaourt -Syu --noconfirm > /dev/null
yaourt -Sy runit --noconfirm > /dev/null

mkdir /services


yaourt -S -cc --noconfirm > /dev/null
rm -rf /var/cache/pacman/pkg/*
rm -rf /build

