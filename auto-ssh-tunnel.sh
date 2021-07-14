#!/usr/bin/bash
AUTO=$(which autossh)
echo $AUTO
echo "yes" | $AUTO -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" -NL 27017:127.0.0.1:27017 -i "/home/raychorn/.ssh/id_rsa" ubuntu@34.197.108.7

