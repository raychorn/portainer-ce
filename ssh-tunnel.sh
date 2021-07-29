#!/usr/bin/bash

TEST=$(netstat -tunlp | grep "127.0.0.1:27017")
echo "TEST=$TEST"

if [ "$TEST." = '.' ]; then
	echo "No tunnel found so starting the tunnel."
        ssh -NL 27017:127.0.0.1:27017 -i "/home/raychorn/.ssh/id_rsa" ubuntu@34.197.108.78
else
	echo "Yes tunnel found so doing nothing."
fi


