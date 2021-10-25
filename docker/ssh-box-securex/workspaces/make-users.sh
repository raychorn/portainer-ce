#!/bin/bash

ROOTDIR=$(dirname "$0")
if [ "$ROOTDIR" = "." ]; then
    ROOTDIR=$(pwd)
fi
echo "1. ROOTDIR:$ROOTDIR"

ETC_SSH=$ROOTDIR/etc-ssh

GROUP=securex

groupadd $GROUP

USERNAME=radia
if [ ! -d "/home/$USERNAME" ]; then
    adduser --disabled-password --gecos GECOS --shell /bin/bash --home /home/$USERNAME $USERNAME
    echo -e "0rang3Z3bra\n0rang3Z3bra" | (passwd $USERNAME)
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    mkdir -p /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
fi

if [ ! -f "/home/$USERNAME/.ssh/authorized_keys" ]; then
    PUB_KEY=$ETC_SSH/authorized_keys_$USERNAME
    if [ -f "$PUB_KEY" ]; then
        cp $PUB_KEY /home/$USERNAME/.ssh/authorized_keys
        chmod 600 /home/$USERNAME/.ssh/authorized_keys
    else
        echo "Missing $PUB_KEY. Cannot proceed."
        sleeping
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $GROUP:$USERNAME /home/$USERNAME/.ssh
fi

usermod -a -G $GROUP $USERNAME


USERNAME=ramani
if [ ! -d "/home/$USERNAME" ]; then
    adduser --disabled-password --gecos GECOS --shell /bin/bash --home /home/$USERNAME $USERNAME
    echo -e "0rang3Z3bra\n0rang3Z3bra" | (passwd $USERNAME)
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    mkdir -p /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
fi

if [ ! -f "/home/$USERNAME/.ssh/authorized_keys" ]; then
    PUB_KEY=$ETC_SSH/authorized_keys_$USERNAME
    if [ -f "$PUB_KEY" ]; then
        cp $PUB_KEY /home/$USERNAME/.ssh/authorized_keys
        chmod 600 /home/$USERNAME/.ssh/authorized_keys
    else
        echo "Missing $PUB_KEY. Cannot proceed."
        sleeping
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $GROUP:$USERNAME /home/$USERNAME/.ssh
fi

usermod -a -G $GROUP $USERNAME


USERNAME=rajesh
if [ ! -d "/home/$USERNAME" ]; then
    adduser --disabled-password --gecos GECOS --shell /bin/bash --home /home/$USERNAME $USERNAME
    echo -e "0rang3Z3bra\n0rang3Z3bra" | (passwd $USERNAME)
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    mkdir -p /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
fi

if [ ! -f "/home/$USERNAME/.ssh/authorized_keys" ]; then
    PUB_KEY=$ETC_SSH/authorized_keys_$USERNAME
    if [ -f "$PUB_KEY" ]; then
        cp $PUB_KEY /home/$USERNAME/.ssh/authorized_keys
        chmod 600 /home/$USERNAME/.ssh/authorized_keys
    else
        echo "Missing $PUB_KEY. Cannot proceed."
        sleeping
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $GROUP:$USERNAME /home/$USERNAME/.ssh
fi

usermod -a -G $GROUP $USERNAME
