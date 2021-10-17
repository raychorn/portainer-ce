#!/usr/bin/bash

USERNAME=ubuntu
echo "USERNAME=$USERNAME"
LOCAL_PORT=12375
echo "LOCAL_PORT=$LOCAL_PORT"

if [ -z "$USERNAME" ]
then
	echo "Cannot proceed without a USERNAME. Please fix."
	exit
fi

if [ -z "$LOCAL_PORT" ]
then
	echo "Cannot proceed without a LOCAL_PORT. Please fix."
	exit
fi

ID_RSA="~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase"
echo "USERNAME -> $USERNAME"
if [ "$USERNAME." == "raychorn." ]
then
	ID_RSA="../../.ssh/id_rsa"
	echo "ID_RSA -> $ID_RSA"
fi
ID_RSA_VERIFY=$(ssh-add -l | grep SHA256:)
echo "ID_RSA_VERIFY=$ID_RSA_VERIFY"
if [ -z "$ID_RSA_VERIFY" ]
then
	echo "Please follow the inistructions in the readme.md file to add your private key to the ssh-agent."
fi

echo "ID_RSA=$ID_RSA"
echo "LOCAL_PORT=$LOCAL_PORT"

RUN_ONCE=y
if [ "$RUN_ONCE." == "y." ]
then
	echo "Opening the ssh-tunnel"
	ssh -NL $LOCAL_PORT:127.0.0.1:2375 -i "$ID_RSA" -o "StrictHostKeyChecking no" $USERNAME@controller.web-service.org
	echo "ssh-tunnel should be open now."
fi