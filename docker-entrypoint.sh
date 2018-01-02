#!/bin/bash
set -e

trap 'kill -2 1; wait 1' SIGTERM

# if [ "$1" = 'mongod' ]; then
#     #exec /sbin/tini -- -g /usr/bin/mongod
#     exec /usr/bin/mongod "$@"
# fi

exec "$@"