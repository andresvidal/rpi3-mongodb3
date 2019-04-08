#!/bin/bash
set -e

if [ -f /data/db/mongod.lock ]; then
    echo "Old mongod.lock file found! Removing..."
    sudo rm /data/db/mongod.lock
    echo "Removed successfully!"
else
    echo "No old mongod.lock file found, starting normally..."
fi

trap 'kill -2 1; wait 1' SIGTERM

# if [ "$1" = 'mongod' ]; then
#     #exec /sbin/tini -- -g /usr/bin/mongod
#     exec /usr/bin/mongod "$@"
# fi

exec "$@"
