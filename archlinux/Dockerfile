FROM base/archlinux
MAINTAINER Christian Kampka <christian@kampka.net>

RUN mkdir /build
ADD . /build

RUN sh /build/setup.sh

ENTRYPOINT ["/usr/bin/minit"]
CMD ["/usr/bin/runsvdir", "-P", "/services"]
