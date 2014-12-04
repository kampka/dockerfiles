Docker image arch-core
======================

This image provides a very minimal Archlinux installation
that is intended to be used as a base to build more sophisticated containers upon.
It contains little more that `bash`, `pacman` and a filesystem.

This image builds from scratch using the bundled `arch-core.tar.xz` archive.
To rebuild the archive, run `prepare.sh` prior to the docker build.
Note that this script will only work on an already existing Archlinux installation
providing the `pacstrap` utility, which is part of the `arch-install-scripts` package.

Afterwards, the usual ```docker build .``` will produce the image.
