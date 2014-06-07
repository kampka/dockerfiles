#!/bin/sh

[ ! -e /dev/fd ] && ln -s /proc/self/fd /dev/fd
