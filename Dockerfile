#
# Asterisk Dockerfile
#

FROM ubuntu:latest
MAINTAINER Marius Bezuidenhout "marius.bezuidenhout@gmail.com"

ENV TZ Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apt-get update &&\
    apt-get install --no-install-recommends --assume-yes --quiet freeradius freeradius-common freeradius-mysql freeradius-utils libfreeradius3 \
        ca-certificates curl git systemd-cron &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* &&\
    ldconfig

WORKDIR /etc/freeradius
VOLUME ["/etc/freeradius"]

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["freeradius"]
