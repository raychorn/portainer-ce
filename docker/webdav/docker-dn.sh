#!/bin/bash

BASEDIR=$(dirname $0)
SOURCE="${BASH_SOURCE[0]}"
PWD=$(pwd)
echo "BASEDIR -> $BASEDIR"
echo "SOURCE -> $SOURCE"
echo "PWD -> $PWD"

if [ "$BASEDIR." == ".."  ]; then
    BASEDIR=$PWD
fi

if [ -f $BASEDIR/.env ]; then
    echo "Loading environment variables from $BASEDIR/.env"
else
    echo "No environment variables found. Cannot continue."
    exit 1
fi

export $(cat $BASEDIR/.env | sed 's/#.*//g' | xargs)

if [ -f $BASEDIR/PORTS.env ]; then
    echo "Loading environment variables from $BASEDIR/PORTS.env"
    export $(cat $BASEDIR/PORTS.env | sed 's/#.*//g' | xargs)
else
    echo "Cannot Load environment variables from $BASEDIR/PORTS.env so cannot continue."
    exit 1
fi

docker-compose down 
