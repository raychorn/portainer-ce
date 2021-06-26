#!/bin/bash

# https://dev.to/efe136/how-to-enable-mongodb-authentication-with-docker-compose-2nbp

cname="mongodb" 

mongodb_root=/opt/mongodb

mongodb_data_log=$mongodb_root/data/log/
if [[ ! -d $mongodb_data_log ]]
then
    echo "Created $mongodb_data_log"
    sudo mkdir -p $mongodb_data_log
fi
sudo touch $mongodb_root/data/log/mongod.log
sudo cp ./etc/mongod.conf $mongodb_root//etc/mongod.conf
sudo chown -R root:root $mongodb_root
sudo chmod -R 0777 $mongodb_root

docker-compose up -d
#sleep 15s

CID=$(docker ps -qf "name=$cname")
echo "CID=$CID"
if [[ ! $CID. == . ]]
then
    echo "$cname is running"
    echo "Restarting $CID"
    #docker restart $CID
fi
#sleep 5s
