#!/usr/bin/env bash

VAR_LIB_DOCKER_VOLUMES=/var/lib/docker/volumes

VOLUME_NAME=mongocerts
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongocerts

if [ ! -d "$VOLUME_SRC" ]; then
    echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
    exit 1
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

sudo cp -r $VOLUME_SRC/* $VOLUME_DIR
sudo chmod 600 $VOLUME_DIR/*
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongoscripts
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongoscripts

if [ ! -d "$VOLUME_SRC" ]; then
    echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
    exit 1
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

sudo cp -r $VOLUME_SRC/* $VOLUME_DIR
sudo chmod +x $VOLUME_DIR/*.sh
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongoconf
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongoconf

if [ ! -d "$VOLUME_SRC" ]; then
    echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
    exit 1
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

sudo cp -r $VOLUME_SRC/* $VOLUME_DIR
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongodata
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    #docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=~/@3/mongodata1/mongodata.tar.gz

if [ ! -f "$VOLUME_SRC" ]; then
    echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
    exit 1
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

#sudo tar -zxf $VOLUME_SRC --directory $VOLUME_DIR
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongoconfigdb
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongologs
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME
if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    docker volume create --name $VOLUME_NAME --opt type=none --opt device=$TARGET_DIR --opt o=bind
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

echo "END!!! VOLUME_NAME:$VOLUME_NAME"


docker volume create --name=mongoconfigdb

echo ""
echo "------------------------------------------------------------------------"
echo ""
