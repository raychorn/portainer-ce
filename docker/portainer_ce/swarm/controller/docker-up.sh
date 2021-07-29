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

if [ -f $BASEDIR/PORT8000.env ]; then
    echo "Loading environment variables from $BASEDIR/PORT8000.env"
    export $(cat $BASEDIR/PORT8000.env | sed 's/#.*//g' | xargs)
else
    P8000=8000
fi

if [ -f $BASEDIR/PORT9000.env ]; then
    echo "Loading environment variables from $BASEDIR/PORT9000.env"
    export $(cat $BASEDIR/PORT9000.env | sed 's/#.*//g' | xargs)
else
    P9000=9000
fi

P8000=$(findPortInRange 8000 8999 $P8000)
echo "P8000 -> $P8000"
echo "P8000=$P8000" > $BASEDIR/PORT8000.env
export P8000

P9000=$(findPortInRange 9000 9999 $P9000)
echo "P9000 -> $P9000"
echo "P9000=$P9000" > $BASEDIR/PORT9000.env
export P9000

export HOSTIP=$(hostname -i)

docker stack deploy -c portainer-agent-stack.yml portainer
