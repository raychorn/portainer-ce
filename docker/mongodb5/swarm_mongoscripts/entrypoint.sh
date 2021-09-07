#!/bin/bash

INITD=/etc/init.d/mongod
MONGOD=$(which mongod)

RUNLOG=/var/log/mongodb/mongod-daemon.log

echo "1 :: MONGOD:$MONGOD"
if [ -z $MONGOD ]; then
    echo "2 :: MONGOD:$MONGOD"
    RESOLVCONF=/mongoconf/resolv.conf

    echo "3 :: RESOLVCONF:$RESOLVCONF"
    if [ ! -f $RESOLVCONF ]; then
        echo "Cannot find (RESOLVCONF:$RESOLVCONF) so cannot continue."
        exit 1
    fi

    echo "4 :: $RESOLVCONF --> /etc/resolv.conf"
    cp $RESOLVCONF /etc/resolv.conf

    apt-get update -y
    apt-get upgrade -y

    export DEBIAN_FRONTEND=noninteractive
    export TZ=America/Denver

    apt-get install -y tzdata

    apt-get install net-tools -y
    apt install iputils-ping -y

    apt install curl wget unzip gpg gnupg2 -y

    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -

    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list

    apt-get update -y

    ln -T /bin/true /usr/bin/systemctl && apt-get update -y && apt-get install -y mongodb-org=5.0.2 && rm /usr/bin/systemctl

    MONGOCONF=/mongoconf/mongod.conf

    echo "5 :: MONGOCONF:$MONGOCONF"
    if [ ! -f $MONGOCONF ]; then
        echo "MongoDB config file (MONGOCONF:$MONGOCONF) not found."
        exit 1
    fi

    cp $MONGOCONF /etc/mongod.conf

    MONGOD=$(which mongod)

    echo "6 :: MONGOD:$MONGOD"
    if [ ! -f $MONGOD ]; then
        echo "Cannot find mongodb-org-shell.  Please install it and try again."
        exit 1
    fi

    KEYFILE=/mongocerts/keyfile.txt

    echo "7 :: KEYFILE:$KEYFILE"
    if [ ! -f $KEYFILE ]; then
        echo "Cannot find (KEYFILE:$KEYFILE) so cannot continue."
        exit 1
    fi

    chmod 0600 $KEYFILE

    #$MONGOD --bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0 --logpath $RUNLOG --dbpath /data/db --fork

    cat << INITDEOF > $INITD
#!/bin/bash
#
# mongodb     Startup script for the mongodb server
#
# chkconfig: - 64 36
# description: MongoDB Database Server
#
# processname: mongodb
#

# Source function library
. /etc/rc.d/init.d/functions

if [ -f /etc/sysconfig/mongodb ]; then
    . /etc/sysconfig/mongodb
fi

prog="mongod"
mongod="/usr/bin/mongod"
RETVAL=0

start() {
    echo -n $"Starting $prog: "
    daemon $mongod "--bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0 --logpath /var/log/mongodb/mongod-daemon.log --dbpath /data/db --fork --logappend 2>&1 >>/var/log/mongodb.log"
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog
    return $RETVAL
}

stop() {
    echo -n $"Stopping $prog: "
    killproc $prog
    RETVAL=$?
    echo
    [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$prog
    return $RETVAL
}

reload() {
    echo -n $"Reloading $prog: "
    killproc $prog -HUP
    RETVAL=$?
    echo
    return $RETVAL
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    condrestart)
        if [ -f /var/lock/subsys/$prog ]; then
            stop
            start
        fi
        ;;
    reload)
        reload
        ;;
    status)
        status $mongod
        RETVAL=$?
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|condrestart|reload|status}"
        RETVAL=1
esac

exit $RETVAL
INITDEOF

    echo "8 :: INITD:$INITD"
    if [ -f "$INITD" ]; then
        chmod +x $INITD
        chkconfig --add $INITD
        #echo "9 :: INITD:$INITD"
        #service $INITD start
    else
        echo "Cannot find $INITD so cannot continue."
        exit 1
    fi
fi

MONGOD=$(which mongod)
PID=$(ps -ef | grep mongod | grep -v grep | awk '{print $2}')
if [ ! -z $MONGOD ]; then
    if [ ! -z $PID ]; then
        echo "10.0 MongoDB is running (PID:$PID)"
    else
        echo "10.0 :: MONGOD:$MONGOD"
        if [ -f $MONGOD ]; then
            echo "10.1 :: MONGOD:$MONGOD"
            $MONGOD --bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0 --logpath $RUNLOG --dbpath /data/db --fork
        else
            echo "Cannot find mongod:$MONGOD.  Please fix."
            exit 1
        fi
    fi
fi

#echo "Running... MONGOD:$MONGOD, PID:$PID"
while true; do
    echo "Running... MONGOD:$MONGOD, PID:$PID" | tee -a $RUNLOG
    sleep 999999999
done

