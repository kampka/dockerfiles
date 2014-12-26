FROM kampka/archlinux
MAINTAINER Christian Kampka <christian@kampka.net>

ENV LANG en_US.utf8

ADD . /build
RUN sh /build/setup.sh

ADD ./services /services

VOLUME ["/data"]

EXPOSE 5432
