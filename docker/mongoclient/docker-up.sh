#!/bin/bash

# https://dev.to/efe136/how-to-enable-mongodb-authentication-with-docker-compose-2nbp

cname="mongoclient" 

mongoclient_root=/opt/mongoclient

if [[ ! -d $mongoclient_root ]]
then
    echo "Created $mongoclient_root"
    sudo mkdir -p $mongoclient_root
fi
sudo chown -R root:root $mongoclient_root
sudo chmod -R 0777 $mongoclient_root

docker-compose up -d
