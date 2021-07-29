#!/bin/bash

# pihole -a -p

RESOLV=/etc/resolv.conf

sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved.service

if [ -f $RESOLV ]; then
    rm -f $RESOLV
fi

sudo service network-manager restart

docker-compose up -d
