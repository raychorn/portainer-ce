#!/bin/bash

# https://www.nosqlclient.com/docs/

# https://dev.to/efe136/how-to-enable-mongodb-authentication-with-docker-compose-2nbp

mongoclient_root=/opt/mongoclient

if [[ ! -d $mongoclient_root ]]
then
    echo "Created $mongoclient_root"
    sudo mkdir -p $mongoclient_root
fi

# DESKTOP-TCGHL6H

docker run -d -e MONGO_URL=mongodb://admin:R3stful0rang3z3bra@10.0.0.173:27017 -p 3000:3000 -v $mongoclient_root:/data/db mongoclient/mongoclient:latest
