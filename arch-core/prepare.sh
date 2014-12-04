#!/bin/bash

set -e

which pacstrap >/dev/null || echo "The pacstrap command was not found. Cannot continue."

CURRENT_DIR="$(pwd)"
BUILD_DIR="$(mktemp -d -p $CURRENT_DIR arch-core-XXXXXXXX)"

CMD_PREFIX=""
[ "$(id -u)" -ne 0 ] && CMD_PREFIX="sudo"

trap "$CMD_PREFIX rm -rf $BUILD_DIR" EXIT


$CMD_PREFIX pacstrap -c -d -G "$BUILD_DIR" filesystem bash pacman haveged

cd "$BUILD_DIR"

$CMD_PREFIX tar cvJf "$CURRENT_DIR/arch-core.tar.xz" *
