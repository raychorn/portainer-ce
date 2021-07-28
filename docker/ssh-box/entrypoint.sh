#!/bin/bash

VENV=/workspaces/.venv
REQS=/workspaces/requirements.txt

python39=$(which python3.9)
pip3=$(which pip3)

echo "python39=$python39"
echo "pip3=$pip3"
#$pip3 install -r /workspaces/$REQS
#$python39 /workspaces/python_runner/cloudns-python/WindowsDynURL/dynamic-url-python.py

apt-get update -y
apt-get upgrade -y
echo "2" | apt-get install openssh-server -y
apt-get install net-tools -y
apt install iputils-ping -y

apt-get install wakeonlan -y

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
else
    echo "Missing $PUB_KEY. Cannot proceed."
    exit 1
fi

service ssh restart

while true; do
  echo "Sleeping... this is what this is supposed to do but this keesp the container running forever and it is doing wakeonlan's."
  wakeonlan 7e:d3:9b:af:f3:59
  wakeonlan a8:a1:59:60:bd:3e
  wakeonlan 00:68:eb:ad:0d:3a
  sleep 60s
done
exit
