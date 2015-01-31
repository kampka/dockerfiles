FROM kampka/web
MAINTAINER Christian Kampka <christian@kampka.net>

ADD . /build
RUN sh /build/setup.sh

VOLUME ["/data"]

EXPOSE 80
