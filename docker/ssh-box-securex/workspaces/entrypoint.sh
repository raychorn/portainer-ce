#!/bin/bash

VENV=/workspaces/.venv
REQS=/workspaces/requirements.txt

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

NANO=$(which nano)

if [ -z "$NANO" ]; then
    echo "NANO is not installed. Installing now..."
    apt-get nano -y
    NANO=$(which nano)
fi

echo "NANO=$NANO"

ETC_SSH=/workspaces/etc-ssh

if [[ -d $ETC_SSH ]]
then
    echo "."
    cp /workspaces/etc-ssh/sshd_config /etc/ssh/sshd_config
else
    mkdir $ETC_SSH
fi

# bootstrap to get the config files.
#echo "cp -R /etc/ssh $ETC_SSH"
#cp -R /etc/ssh $ETC_SSH

PUB_KEY=/root/.ssh/authorized_keys
PUB_KEY_HOME=$(dirname $PUB_KEY)

if [[ -f $PUB_KEY ]]
then
    echo "Found $PUB_KEY and $PUB_KEY_HOME."
    chmod -R 600 $PUB_KEY_HOME
    ls -la $PUB_KEY_HOME
else
    echo "Missing $PUB_KEY. Cannot proceed."
    exit 1
fi

service ssh restart

while true; do
  echo "Sleeping... waiting for a user to login."
  sleep 9999
done

