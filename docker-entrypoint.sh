#!/bin/bash
set -x

#trap 'kill -2 1; wait 1' SIGTERM

if [ "$1" = 'mongod' ]; then

    #exec gosu postgres "$@"
    #exec /sbin/tini -- -g /usr/bin/mongod
    exec /usr/bin/mongod 
fi

exec "$@"