#!/bin/bash

docker-compose -f docker-compose-deployer.yml up -d

echo "Sleeping..."
sleep 5

CID=$(docker ps -q -f name=docker-deployer)
echo "CID:$CID"
docker exec -it $CID /bin/bash -c "mkdir -p /workspaces"
docker cp entrypoint.sh $CID:/workspaces/entrypoint.sh
docker cp .env $CID:/workspaces/.env

#docker cp etc-hosts $CID:/workspaces/etc-hosts
docker cp etc-resolv.conf $CID:/workspaces/etc-resolv.conf

docker cp get-pip.py $CID:/workspaces/get-pip.py

GZ_FILE=etc-pihole.tar.gz
if [ -f "$GZ_FILE" ]; then
    rm $GZ_FILE
fi

tar czfz $GZ_FILE --directory=/home/raychorn/__projects/portainer-ce/docker/pi-hole/etc-pihole .
docker cp $GZ_FILE $CID:/workspaces/$GZ_FILE

GZ_FILE=etc-dnsmasq_d.tar.gz
if [ -f "$GZ_FILE" ]; then
    rm $GZ_FILE
fi

tar czfz $GZ_FILE --directory=/home/raychorn/__projects/portainer-ce/docker/pi-hole/etc-dnsmasq.d .
docker cp $GZ_FILE $CID:/workspaces/$GZ_FILE

docker cp compose-1.29.2.tar.gz $CID:/workspaces/compose-1.29.2.tar.gz

echo "Entering the container..."
docker exec -it $CID /bin/bash
