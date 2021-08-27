#!/bin/bash

CONTROLLER_DOCKER_CONTEXT=controller

PWD=$(pwd)
DIR0=$(dirname $0)

if [ "$DIR0." == ".." ]; then
    DIR0=$PWD
fi
echo "DIR0=$DIR0"
echo "PWD=$PWD"

if [ -f "$DIR0/.env" ]; then
    echo "Importing environment variables."
    export $(cat $DIR0/.env | sed 's/#.*//g' | xargs)
    echo "Done importing environment variables."
else
    echo "ERROR: Environment variables not found. Please run the following command to generate them:"
    sleeping
fi

TUNNELPORTTEST=$(netstat -tunlp | grep 12375)
echo "TUNNELPORTTEST=$TUNNELPORTTEST"

if [ "$TUNNELPORTTEST." = '.' ]; then
    echo "No tunnel active, so cannot continue."
    exit 1
fi

TEST=$(docker context ls | grep $CONTROLLER_DOCKER_CONTEXT)
echo "TEST=$TEST"

if [ "$TEST." = '.' ]; then
    echo "No conext found so creating the context."
    docker context create $CONTROLLER_DOCKER_CONTEXT --docker "host=tcp://127.0.0.1:12375"
fi

docker context use $CONTROLLER_DOCKER_CONTEXT

TEST2=$(docker ps | grep amazon-ecs-agent)

if [ "$TEST2." = '.' ]; then
    echo "Could not connect to the remote context, so cannot continue.  Please check your config and try again, maybe."
    exit 1
fi

docker ps
