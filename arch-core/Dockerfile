FROM scratch

ADD arch-core.tar.xz /

ADD . /build

RUN /build/setup.sh

ENTRYPOINT ["/usr/bin/sh", "-c"]
