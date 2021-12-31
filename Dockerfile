#
# Freeradius Dockerfile
#

FROM alpine:latest
LABEL maintainer="Marius Bezuidenhout <marius.bezuidenhout@gmail.com>"

ENV TZ Etc/UTC
ENV PATH "/freeradius/bin:/freeradius/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
COPY installer.sh /usr/local/bin/
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apk add --no-cache talloc ca-certificates bash libwbclient gdbm tzdata tar libpcap mariadb-connector-c postgresql-libs libpq \
    && apk add --no-cache --virtual .build-deps talloc-dev alpine-sdk git linux-headers openssl-dev openldap-dev ruby gdbm-dev mariadb-connector-c-dev \
sqlite-dev postgresql-dev libpcap-dev \
    && git clone -b release_3_0_25 https://github.com/FreeRADIUS/freeradius-server.git \
    && cd freeradius-server \
    && chmod +x /usr/local/bin/installer.sh \
    && installer.sh \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf freeradius-server \
    && mkdir -p /usr/src/freeradius \
    && mv /freeradius/etc /usr/src/freeradius \
    && mkdir /freeradius/etc

WORKDIR /freeradius
VOLUME ["/freeradius/etc"]
EXPOSE 1812/tcp 1813/tcp 1814/tcp 1812/udp 1813/udp 1814/udp

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["radiusd"]
