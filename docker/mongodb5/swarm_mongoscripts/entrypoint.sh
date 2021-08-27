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

echo "Starting MongoDB ($MONGOD)..."
$MONGOD --bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0
