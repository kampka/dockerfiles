FROM kampka/arch-core
MAINTAINER Christian Kampka <christian@kampka.net>

ADD . /build

RUN sh /build/setup.sh

ENV SVDIR /services
ENTRYPOINT ["/usr/bin/minit"]
CMD ["/usr/bin/runsvdir", "-P", "/services"]

