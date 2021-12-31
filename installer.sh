#!/bin/bash
set -euo pipefail

EXTRA=""
case $(uname -m) in
    i386) ;&
    i686)    ;;
    x86_64)  EXTRA="--build=x86_64-unknown-linux-gnu" ;;
    armv6l) ;&
    armv7l)  ;;
    aarch64)  EXTRA="--build=aarch64-unknown-linux-gnu" ;;
    ppc64)   ;;
    s390x)   ;;
esac

./configure --sysconfdir /freeradius/etc --bindir /freeradius/bin --sbindir /freeradius/sbin --without-rlm_cache_memcached --without-rlm_couchbase \
--without-rlm_eap_ikev2 --without-rlm_eap_tnc --without-rlm_idn --without-rlm_krb5 --without-rlm_opendirectory --without-rlm_pam --without-rlm_perl \
--without-rlm_python --without-rlm_python3 --without-rlm_redis --without-rlm_rest --without-rlm_ruby --without-rlm_securid --without-rlm_sql_unixodbc \
--without-rlm_sql_oracle --without-rlm_sql_freetds --without-rlm_sql_db2 --without-rlm_sql_firebird --without-rlm_sql_iodbc --without-rlm_sql_mongo $EXTRA

make install
