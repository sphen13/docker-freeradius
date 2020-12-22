#
# Freeradius Dockerfile
#

FROM alpine:latest
LABEL maintainer="Marius Bezuidenhout <marius.bezuidenhout@gmail.com>"

ENV TZ Etc/UTC
ENV PATH "/freeradius/bin:/freeradius/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apk add --no-cache talloc ca-certificates bash libwbclient gdbm tzdata tar libpcap mariadb-connector-c postgresql-libs libpq &&\
    apk add --no-cache --virtual .build-deps talloc-dev alpine-sdk git linux-headers openssl-dev openldap-dev ruby gdbm-dev mariadb-connector-c-dev \
sqlite-dev postgresql-dev libpcap-dev &&\
    git clone -b release_3_0_21 https://github.com/FreeRADIUS/freeradius-server.git &&\
    cd freeradius-server &&\
    ./configure --sysconfdir /freeradius/etc --bindir /freeradius/bin --sbindir /freeradius/sbin --without-rlm_cache_memcached --without-rlm_couchbase \
--without-rlm_eap_ikev2 --without-rlm_eap_tnc --without-rlm_idn --without-rlm_krb5 --without-rlm_opendirectory --without-rlm_pam --without-rlm_perl \
--without-rlm_python --without-rlm_python3 --without-rlm_redis --without-rlm_rest --without-rlm_ruby --without-rlm_securid --without-rlm_sql_unixodbc \
--without-rlm_sql_oracle --without-rlm_sql_freetds --without-rlm_sql_db2 --without-rlm_sql_firebird --without-rlm_sql_iodbc --without-rlm_sql_mongo &&\
    make install &&\
    apk del .build-deps &&\
    cd .. &&\
    rm -Rf freeradius-server &&\
    mkdir -p /usr/src/freeradius &&\
    mv /freeradius/etc /usr/src/freeradius &&\
    mkdir /freeradius/etc

WORKDIR /freeradius
VOLUME ["/freeradius/etc"]
EXPOSE 1812/tcp 1813/tcp 1814/tcp 1812/udp 1813/udp 1814/udp

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["radiusd"]
