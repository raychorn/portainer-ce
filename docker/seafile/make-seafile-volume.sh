#!/usr/bin/env bash

# https://docs.docker.com/storage/volumes/

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

mkdir -p /srv/seafile_mysql
docker volume create -d local -o o=bind -o type=volume -o device=/srv/seafile_mysql --name seafile_mysql

mkdir -p /srv/seafile_data
docker volume create -d local -o o=bind -o type=volume -o device=/srv/seafile_data --name seafile_data
