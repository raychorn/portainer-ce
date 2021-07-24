#!/bin/bash
BASEDIR=..
export $(cat $BASEDIR/.env | sed 's/#.*//g' | xargs)

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

docker stack deploy -c portainer-agent-stack.yml portainer
