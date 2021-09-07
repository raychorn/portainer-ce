#!/bin/bash

RESOLVCONF=/mongoconf/resolv.conf

if [ ! -f $RESOLVCONF ]; then
    echo "Cannot find (RESOLVCONF:$RESOLVCONF) so cannot continue."
    exit 1
fi

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

if [ ! -f $MONGOCONF ]; then
    echo "MongoDB config file (MONGOCONF:$MONGOCONF) not found."
    exit 1
fi

cp $MONGOCONF /etc/mongod.conf

MONGOD=$(which mongod)

if [ ! -f $MONGOD ]; then
    echo "Cannot find mongodb-org-shell.  Please install it and try again."
    exit 1
fi

KEYFILE=/mongocerts/keyfile.txt

if [ ! -f $KEYFILE ]; then
    echo "Cannot find (KEYFILE:$KEYFILE) so cannot continue."
    exit 1
fi

chmod 0600 $KEYFILE

RUNLOG=/var/log/mongodb/mongod-daemon.log

$MONGOD --bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0 --logpath $RUNLOG --dbpath /data/db --fork

INITD=/etc/init.d/mongod
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

while true; do
    echo "Sleeping..." >> $RUNLOG
    sleep 9999
done

