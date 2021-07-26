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

# bash function to run a command as a specific user
findPortInRange() {
    local portLow=$1
    local portHi=$2
    local port=$3
    #echo "DEBUG portLow -> $portLow,  portHi -> $portHi, port -> $port"

    i=0
    #echo "BEGIN: Checking for Ports ($portLow to $portHi)."
    while [ $i -le 1000 ]
    do
        PORTTEST=$(sudo netstat -tunlp | grep $port)
        if [[ -z $PORTTEST ]]; then
            #echo "PORT $port is not defined."
            break
        else
            port=$(shuf -i $portLow-$portHi -n 1)
        fi

        #echo "PORTS ($portLow to $portHi) iter: $i"
        ((i++))
        sleep 1
        if [ "$i" == 100 ]; then
            break
        fi
    done
    echo $port
}

export $(cat $BASEDIR/.env | sed 's/#.*//g' | xargs)

if [ -f $BASEDIR/PORTS.env ]; then
    echo "Loading environment variables from $BASEDIR/PORTS.env"
    export $(cat $BASEDIR/PORTS.env | sed 's/#.*//g' | xargs)
else
    PORT=8088
fi

PORT=$(findPortInRange 8088 8999 $PORT)
PORT2=$PORT
((PORT2++))
PORT2=$(findPortInRange 8088 8999 $PORT2)

echo "PORT -> $PORT"
echo "PORT2 -> $PORT2"

echo "PORT=$PORT" > $BASEDIR/PORTS.env
echo "PORT2=$PORT2" >> $BASEDIR/PORTS.env

export $(cat $BASEDIR/PORTS.env | sed 's/#.*//g' | xargs)

docker-compose up -d
