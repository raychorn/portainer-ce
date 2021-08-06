#!/bin/bash

BASEDIR=$(dirname $0)
echo "BASEDIR -> $BASEDIR"

export $(cat $BASEDIR/.env | sed 's/#.*//g' | xargs)

export $(cat $BASEDIR/PORTS.env | sed 's/#.*//g' | xargs)

docker-compose down 
