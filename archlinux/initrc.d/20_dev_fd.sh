#!/bin/sh

set -e

[ ! -d /dev/fd ] && ln -s /proc/self/fd /dev/fd
exit 0
