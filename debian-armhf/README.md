Docker image debian-armhf
==============================

This image provides a very minimal Debian installation
that is intended to be used as a base to build more sophisticated containers upon.
It is build using a tarball generated with debootstrap.

Architecture Note
-----------------
This image is built using the armhf architecture.
In order to build and run it on a x86 based system,
the host needs to be set up to support [binfmt_misc](https://www.kernel.org/doc/Documentation/binfmt_misc.txt).
This requirement prohibits this image to be built as a trusted build on the docker hub.
