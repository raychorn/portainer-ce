#!/bin/bash

EXTERNAL_HOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)

#docker-compose -H tcp://$EXTERNAL_HOST:2375 up -d

docker-compose -H tcp://host.docker.internal:2375 up -d
#docker stack deploy -c portainer-agent-stack.yml portainer

#docker-compose up -d
