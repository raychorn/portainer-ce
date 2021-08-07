#!/bin/bash

VENV=/workspaces/.venv
REQS=/workspaces/requirements.txt

PYTHON39=$(which python3.9)
PIP3=$(which pip3)

apt-get update -y && apt-get upgrade -y

export DEBIAN_FRONTEND=noninteractive

export TZ=America/Denver

apt-get install -y tzdata wget

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

apt install libc6 libglapi-mesa libxdamage1 libxfixes3 libxcb-glx0 libxcb-dri2-0 libxcb-dri3-0 libxcb-present0 libxcb-sync1 libxshmfence1 libxxf86vm1 -y

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -

wget https://www.dropbox.com/download?dl=packages/dropbox.py -O ~/dropbox.py

echo fs.inotify.max_user_watches=100000 | tee -a /etc/sysctl.conf; sysctl -p

~/.dropbox-dist/dropboxd

while true; do
  echo "Sleeping... waiting for dropbox to do its thing and this is normal."
  sleep 9999
done

