#!/bin/bash

HOSTNAME=$(hostname)
##################################################
MONGOSCRIPTS=mongoscripts_$HOSTNAME

MONGOSCRIPTS_TEST=$(docker volume ls | grep $MONGOSCRIPTS)

if [ -z "$MONGOSCRIPTS_TEST" ]; then
    docker volume create $MONGOSCRIPTS
fi

MONGOSCRIPTS_DIR=/srv/mongoscripts

if [ -d "$MONGOSCRIPTS_DIR" ]; then
    echo "INFO: MONGOSCRIPTS_DIR:$MONGOSCRIPTS_DIR directory exists. Proceeding."
else
    echo "ERROR: MONGOSCRIPTS_DIR:$MONGOSCRIPTS_DIR directory does not exist. Cannot continue."
    exit
fi

MONGOSCRIPTS_VOLUME_DIR=$(docker volume inspect $MONGOSCRIPTS | jq -r '.[0].Mountpoint')

if [ -d "$MONGOSCRIPTS_VOLUME_DIR" ]; then
    echo "INFO: MONGOSCRIPTS_VOLUME_DIR:$MONGOSCRIPTS_VOLUME_DIR volume directory exists. Proceeding."
else
    echo "ERROR: MONGOSCRIPTS_VOLUME_DIR:$MONGOSCRIPTS_VOLUME_DIR volume directory does not exist. Cannot continue."
    exit
fi

cp $MONGOSCRIPTS_DIR/*.sh $MONGOSCRIPTS_VOLUME_DIR/.

##################################################

MONGOCERTS=mongocerts_$HOSTNAME

MONGOCERTS_TEST=$(docker volume ls | grep $MONGOCERTS)

if [ -z "$MONGOCERTS_TEST" ]; then
    docker volume create $MONGOCERTS
fi

MONGOCERTS_DIR=/srv/mongocerts

if [ -d "$MONGOCERTS_DIR" ]; then
    echo "INFO: MONGOCERTS_DIR:$MONGOCERTS_DIR directory exists. Proceeding."
else
    echo "ERROR: MONGOCERTS_DIR:$MONGOCERTS_DIR directory does not exist. Cannot continue."
    exit
fi

MONGOCERTS_VOLUME_DIR=$(docker volume inspect $MONGOCERTS | jq -r '.[0].Mountpoint')

if [ -d "$MONGOCERTS_VOLUME_DIR" ]; then
    echo "INFO: MONGOCERTS_VOLUME_DIR:$MONGOCERTS_VOLUME_DIR volume directory exists. Proceeding."
else
    echo "ERROR: MONGOCERTS_VOLUME_DIR:$MONGOCERTS_VOLUME_DIR volume directory does not exist. Cannot continue."
    exit
fi

cp $MONGOCERTS_DIR/*.txt $MONGOCERTS_VOLUME_DIR/.
##################################################

MONGOCONF=mongoconf_$HOSTNAME

MONGOCONF_TEST=$(docker volume ls | grep $MONGOCONF)

if [ -z "$MONGOCERTS_TEST" ]; then
    docker volume create $MONGOCONF
fi

MONGOCONF_DIR=/srv/mongoconf

if [ -d "$MONGOCONF_DIR" ]; then
    echo "INFO: MONGOCONF_DIR:$MONGOCONF_DIR directory exists. Proceeding."
else
    echo "ERROR: MONGOCONF_DIR:$MONGOCONF_DIR directory does not exist. Cannot continue."
    exit
fi

MONGOCONF_VOLUME_DIR=$(docker volume inspect $MONGOCONF | jq -r '.[0].Mountpoint')

if [ -d "$MONGOCONF_VOLUME_DIR" ]; then
    echo "INFO: MONGOCONF_VOLUME_DIR:$MONGOCONF_VOLUME_DIR volume directory exists. Proceeding."
else
    echo "ERROR: MONGOCONF_VOLUME_DIR:$MONGOCONF_VOLUME_DIR volume directory does not exist. Cannot continue."
    exit
fi

cp $MONGOCONF_DIR/*.conf $MONGOCONF_VOLUME_DIR/.
##################################################
