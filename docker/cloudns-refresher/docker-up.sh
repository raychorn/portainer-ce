#!/bin/bash

DIR0=$(dirname $0)
echo "DIR0=$DIR0"

EXTERNAL_HOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)

$(which python3.9) $DIR0/scripts/set_external_hosts.py $(pwd) $EXTERNAL_HOST

#docker-compose up -d
docker stack deploy -c docker-compose-stack.yml cloudns-refresher
