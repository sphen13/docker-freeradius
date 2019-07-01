#
# Freeradius Dockerfile
#

FROM arm32v6lalpine:latest
LABEL maintainer="Marius Bezuidenhout <marius.bezuidenhout@gmail.com>"

ENV TZ Etc/UTC
ENV PATH "/freeradius/bin:/freeradius/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apk add --no-cache talloc ca-certificates bash libwbclient gdbm &&\
    apk add --no-cache --virtual .build-deps talloc-dev alpine-sdk git linux-headers openssl-dev openldap-dev ruby gdbm-dev &&\
    apk add --no-cache tar &&\
    git clone -b release_3_0_19 https://github.com/FreeRADIUS/freeradius-server.git &&\
    cd freeradius-server &&\
    ./configure --sysconfdir /freeradius/etc --bindir /freeradius/bin --sbindir /freeradius/sbin &&\
    make install &&\
    apk del .build-deps &&\
    cd .. &&\
    rm -Rf freeradius-server &&\
    mkdir -p /usr/src/freeradius &&\
    mv /freeradius/etc /usr/src/freeradius &&\
    mkdir /freeradius/etc

WORKDIR /freeradius
VOLUME ["/freeradius/etc"]
EXPOSE 1812/tcp 1813/tcp

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["radiusd"]
