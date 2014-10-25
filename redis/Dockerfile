FROM kampka/archlinux
MAINTAINER Christian Kampka <christian@kampka.net>

ADD . /build
RUN sh /build/setup.sh

ADD ./services /services

VOLUME ["/data"]

EXPOSE 6379
