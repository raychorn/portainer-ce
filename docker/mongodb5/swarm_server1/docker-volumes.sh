#!/usr/bin/env bash

CLEAR_BEFORE=1
VAR_LIB_DOCKER_VOLUMES=/var/lib/docker/volumes

VOLUME_NAME=mongocerts
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME

echo "CLEAR_BEFORE:$CLEAR_BEFORE"
if [ "$CLEAR_BEFORE" == "1" ]; then
    if [ -d "$VOLUME_DIR" ]; then
        sudo rm -f -R $VOLUME_DIR/
    fi
    if [ -d "$TARGET_DIR" ]; then
        sudo rm -f -R $TARGET_DIR/
    fi
    VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
    if [ ! -z "$VOLUME_TEST" ]; then
        docker volume rm $VOLUME_NAME
    fi
fi

if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongocerts

if [ ! -d "$VOLUME_SRC" ]; then
    VOLUME_SRC=/home/raychorn/@3/mongocluster/mongocerts1

    if [ ! -d "$VOLUME_SRC" ]; then
        echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
        exit 1
    fi
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

echo "$VOLUME_SRC/keyfile.txt --> $TARGET_DIR/keyfile.txt"
sudo cp $VOLUME_SRC/keyfile.txt $TARGET_DIR/keyfile.txt
sudo chmod 600 $TARGET_DIR/keyfile.txt
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongoscripts

VOLUME_NAME=mongoscripts
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME

echo "CLEAR_BEFORE:$CLEAR_BEFORE"
if [ "$CLEAR_BEFORE" == "1" ]; then
    if [ -d "$VOLUME_DIR" ]; then
        sudo rm -f -R $VOLUME_DIR/
    fi
    if [ -d "$TARGET_DIR" ]; then
        sudo rm -f -R $TARGET_DIR/
    fi
    VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
    if [ ! -z "$VOLUME_TEST" ]; then
        docker volume rm $VOLUME_NAME
    fi
fi

if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

if [ -d "$VOLUME_SRC" ]; then
    echo "$VOLUME_SRC/* --> $TARGET_DIR"
    sudo cp -r $VOLUME_SRC/* $TARGET_DIR
    sudo chmod +x $TARGET_DIR/*.sh
    echo "END!!! VOLUME_NAME:$VOLUME_NAME"
fi

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongoconf
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME

echo "CLEAR_BEFORE:$CLEAR_BEFORE"
if [ "$CLEAR_BEFORE" == "1" ]; then
    if [ -d "$VOLUME_DIR" ]; then
        sudo rm -f -R $VOLUME_DIR/
    fi
    if [ -d "$TARGET_DIR" ]; then
        sudo rm -f -R $TARGET_DIR/
    fi
    VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
    if [ ! -z "$VOLUME_TEST" ]; then
        docker volume rm $VOLUME_NAME
    fi
fi

if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongoconf

if [ ! -d "$VOLUME_SRC" ]; then
    VOLUME_SRC=/home/raychorn/@3/mongocluster/mongoconf1

    if [ ! -d "$VOLUME_SRC" ]; then
        echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
        exit 1
    fi
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

echo "$VOLUME_SRC/* --> $TARGET_DIR"
sudo cp -r $VOLUME_SRC/* $TARGET_DIR
echo "END!!! VOLUME_NAME:$VOLUME_NAME"

echo ""
echo "------------------------------------------------------------------------"
echo ""

VOLUME_NAME=mongodata
echo "BEGIN: VOLUME_NAME:$VOLUME_NAME"
TARGET_DIR=/srv/$VOLUME_NAME

echo "CLEAR_BEFORE:$CLEAR_BEFORE"
if [ "$CLEAR_BEFORE" == "1" ]; then
    if [ -d "$VOLUME_DIR" ]; then
        sudo rm -f -R $VOLUME_DIR/
    fi
    if [ -d "$TARGET_DIR" ]; then
        sudo rm -f -R $TARGET_DIR/
    fi
    VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
    if [ ! -z "$VOLUME_TEST" ]; then
        docker volume rm $VOLUME_NAME
    fi
fi

if [ ! -d "$TARGET_DIR" ]; then
    sudo mkdir -p $TARGET_DIR
fi

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

VOLUME_SRC=/home/raychorn/@3/mongodata1/mongodata.tar.gz

if [ ! -f "$VOLUME_SRC" ]; then
    VOLUME_SRC=/home/raychorn/@3/mongocluster/mongodata1/mongodata.tar.gz

    if [ ! -f "$VOLUME_SRC" ]; then
        echo "Cannot find VOLUME_SRC:$VOLUME_SRC so cannot continue."
        exit 1
    fi
fi

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

echo "unpacking $VOLUME_SRC --> $TARGET_DIR"
sudo tar -zxf $VOLUME_SRC --directory $TARGET_DIR
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

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
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

VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME | awk '{print $2}')
if [ "$VOLUME_TEST." != "$VOLUME_NAME." ]; then
    docker volume create --driver local --opt type=none --opt device=$TARGET_DIR --opt o=bind $VOLUME_NAME
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
