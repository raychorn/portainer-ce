#!/bin/bash

EXTERNAL_HOST=$(ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1)
echo "EXTERNAL_HOST=$EXTERNAL_HOST"

PORT8000=$(netstat -tunlp | grep 8000)
PORT9000=$(netstat -tunlp | grep 8000)

if [[ -z $PORT8000 ]]; then
    echo "PORT 8000 is not defined."
else
    echo "PORT 8000 is defined so cannot continue."
    exit 1
fi

if [[ -z $PORT9000 ]]; then
    echo "PORT 9000 is not defined."
else
    echo "PORT 9000 is defined so cannot continue."
    exit 1
fi

# docker swarm init --advertise-addr $(hostname -I | awk '{ print $1 }'):2377

docker-compose -H tcp://$EXTERNAL_HOST:2375 up -d

#docker-compose -H tcp://host.docker.internal:2375 up -d
#docker stack deploy -c portainer-agent-stack.yml portainer

#docker-compose up -d
