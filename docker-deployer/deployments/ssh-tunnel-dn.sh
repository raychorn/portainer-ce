#!/bin/bash

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

if [ "$TUNNELPORTTEST." != '.' ]; then
    PID=$(ps -aux | grep 12375:127.0.0.1:2375 | awk '{print $2}' | head -1)
    echo "PID=$PID"
    sudo kill -9 $PID
fi
