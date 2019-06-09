#
# Freeradius Dockerfile
#

FROM ubuntu:latest
LABEL maintainer="Marius Bezuidenhout <marius.bezuidenhout@gmail.com>"

ENV TZ Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet freeradius freeradius-common freeradius-mysql freeradius-utils libfreeradius3 \
        ca-certificates curl git systemd-cron &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    mv /etc/freeradius /usr/src &&\
    mkdir /etc/freeradius &&\
    chown freerad:freerad /etc/freeradius &&\
    ldconfig

WORKDIR /etc/freeradius
VOLUME ["/etc/freeradius"]
EXPOSE 1812/tcp 1813/tcp

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["freeradius"]
