#!/bin/bash

SLEEP=false

ROOTDIR=/workspaces/portainer-ce-1.0.0/docker/ssh-box-securex
echo "1. ROOTDIR:$ROOTDIR"

if [ ! -d "$ROOTDIR" ]; then
    ROOTDIR=/workspaces
else
    ROOTDIR=$ROOTDIR/workspaces
fi
echo "2. ROOTDIR:$ROOTDIR"

VENV=$ROOTDIR/.venv
REQS=$ROOTDIR/requirements.txt

PYTHON39=$(which python3.9)
PIP3=$(which pip3)

apt-get update -y && apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive

export TZ=America/Denver

apt-get install -y tzdata

if [ -z "$PYTHON39" ]; then
    echo "Python 3.9 is not installed. Installing now..."
    apt-get update -y
    apt install software-properties-common -y
    add-apt-repository ppa:deadsnakes/ppa -y
    apt-get install python3.9 -y
    PYTHON39=$(which python3.9)
fi

if [ -z "$PIP3" ]; then
    echo "Pip 3 is not installed. Installing now..."
    apt-get install python3-pip -y
    PIP3=$(which pip3)
fi

echo "python39=$PYTHON39"
echo "PIP3=$PIP3"

apt-get update -y
echo "2" | apt-get install openssh-server -y
apt-get install net-tools -y
apt install iputils-ping -y
apt-get install nano -y

ETC_SSH=$ROOTDIR/etc-ssh
ETC_SUDOERS=$ROOTDIR/etc-sudoers

if [[ ! -d $ETC_SSH ]]
then
    echo "Cannot find ETC_SSH:$ETC_SSH so cannot continue."
    exit 1
fi

if [[ ! -d $ETC_SUDOERS ]]
then
    echo "Cannot find ETC_SUDOERS:$ETC_SUDOERS so cannot continue."
    exit 1
fi

if [[ -d $ETC_SSH ]]
then
    echo "Setting up $ETC_SSH/sshd_config -> /etc/ssh/sshd_config"
    if [[ -f $ETC_SSH/sshd_config ]]; then
        cp $ETC_SSH/sshd_config /etc/ssh/sshd_config
    else
        echo "No sshd_config found in $ETC_SSH"
        exit 1
    fi
fi

service ssh restart

USERNAME=raychorn
if [ ! -d "/home/$USERNAME" ]; then
    adduser --disabled-password --gecos GECOS --shell /bin/bash --home /home/$USERNAME $USERNAME
    echo -e "peekab00\npeekab00" | (passwd $USERNAME)
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    mkdir -p /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
fi

PUB_KEY=$ETC_SSH/authorized_keys_$USERNAME
echo "PUB_KEY:$PUB_KEY"
if [ ! -f "/home/$USERNAME/.ssh/authorized_keys" ]; then
    if [ -f "$PUB_KEY" ]; then
        cp $PUB_KEY /home/$USERNAME/.ssh/authorized_keys
        chmod 600 /home/$USERNAME/.ssh/authorized_keys
    else
        echo "Missing $PUB_KEY. Cannot proceed."
        exit 1
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
fi


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
        exit 1
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
fi


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
        exit 1
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
fi


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
        exit 1
    fi
fi

if [ ! -d "/home/$USERNAME/.ssh" ]; then
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
fi

if [ ! -f "$ETC_SUDOERS" ]; then
    echo "Missing $ETC_SUDOERS. Cannot proceed."
    exit 1
fi

if [ ! -f "/etc/sudoers" ]; then
    echo "Missing /etc/sudoers. Cannot proceed."
    exit 1
fi

SUDOERS_TARGET=/etc/sudoers/users-permissions
cp $ETC_SUDOERS $SUDOERS_TARGET

if [ ! -f "$SUDOERS_TARGET" ]; then
    echo "Missing $SUDOERS_TARGET. Cannot proceed."
    exit 1
fi

echo "SLEEP:$SLEEP"
if [[ "$SLEEP." == "." ]]
then
    while true; do
    echo "Sleeping... waiting for a user to login."
    sleep 999999
    done
else
    echo "DONE."
fi


