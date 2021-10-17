#!/usr/bin/env bash

CONTEXT=$(docker context ls | grep remote-context | awk '{print $1}')

if [ -z "$CONTEXT" ]; then
    docker context create remote-context --docker "host=tcp://127.0.0.1:12375"
    CONTEXT=$(docker context ls | grep remote-context | awk '{print $1}')
fi

echo "CONTEXT: $CONTEXT"

if [ -z "$CONTEXT" ]; then
    echo "ERROR: Could not use remote-context."
    exit 1
fi

docker context use remote-context

docker-compose -f ./docker-compose.yml up -d
