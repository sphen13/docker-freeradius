#!/bin/bash
set -euo pipefail

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

if [ -n "${FREERADIUS_RUN_GID:-}" ]; then
    if [ ! $(getent group radius) ]; then
        addgroup --gid ${FREERADIUS_RUN_GID} radius
    fi
    export FREERADIUS_RUN_GROUP=radius
    sed -ri 's/user\ ?=\ ?freerad$/user\ =\ radius/' /etc/freeradius/3.0/radiusd.conf
    echo "Changing service GID to ${FREERADIUS_RUN_GID}."
else
    export FREERADIUS_RUN_GROUP=freerad
fi

if [ -n "${FREERADIUS_RUN_UID:-}" ]; then
    if [ ! $(getent passwd radius) ]; then
        adduser --gecos "" --ingroup ${FREERADIUS_RUN_GROUP} --no-create-home --disabled-password --disabled-login --uid ${FREERADIUS_RUN_UID} radius
    fi
    export FREERADIUS_RUN_USER=radius
    sed -ri 's/group\ ?=\ ?freerad$/user\ =\ radius/' /etc/freeradius/3.0/radiusd.conf
    echo "Changing service UID to ${FREERADIUS_RUN_UID}."
else
    export FREERADIUS_RUN_USER=freerad
fi

if [ "$1" == 'freeradius' ]; then
    exec freeradius -f
fi

exec "$@"
