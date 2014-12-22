#!/bin/bash

set -e

which pacstrap >/dev/null || echo "The pacstrap command was not found. Cannot continue."

CURRENT_DIR="$(pwd)"
BUILD_DIR="$(mktemp -d -p $CURRENT_DIR arch-core-XXXXXXXX)"

CMD_PREFIX=""
[ "$(id -u)" -ne 0 ] && CMD_PREFIX="sudo"

trap "$CMD_PREFIX rm -rf $BUILD_DIR" EXIT


$CMD_PREFIX pacstrap -c -d -G "$BUILD_DIR" filesystem bash pacman haveged sed
#$CMD_PREFIX arch-chroot "$BUILD_DIR" /bin/bash -c "pacman-key --init"

$CMD_PREFIX arch-chroot "$BUILD_DIR" /bin/bash <<'EOF'

# Inside chroot

haveged -w 4096

rm -fr /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux

pacman -Rs --noconfirm haveged
ln -s /usr/share/zoneinfo/UTC /etc/localtime

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen

echo "Server = https://mirrors.kernel.org/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

sed -i "s/^CheckSpace/#CheckSpace/g" /etc/pacman.conf

EOF

# Outside chroot

cd "$BUILD_DIR"

$CMD_PREFIX tar cvJf "$CURRENT_DIR/arch-core.tar.xz" *
