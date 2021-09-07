#!/usr/bin/env bash

docker-compose -f docker-compose-server1.yml up -d

#docker stack deploy -c docker-compose-server1.yml mongodb5

#docker service create --limit-cpu "4.0" --limit-memory "1g" --dns "10.0.0.196" --reserve-cpu "1.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata,target=/data/db --mount type=volume,source=mongoconf,target=/etc/mongod/ --mount type=volume,source=mongoconfigdb,target=/data/configdb --mount type=volume,source=mongocerts,target=/mongocerts --mount type=volume,source=mongologs,target=/var/log/mongodb --constraint 'node.hostname == server1' --name mongodb1 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" --config "/etc/mongod/mongod.conf"
#docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata2,target=/data/db --mount type=volume,source=mongoconf2,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb2,target=/data/configdb --mount type=volume,source=mongocerts2,target=/mongocerts --mount type=volume,source=mongologs2,target=/var/log/mongodb --constraint 'node.hostname == tp01-2066' --name mongo2 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"
#docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata_docker1,target=/data/db --mount type=volume,source=mongoconf_docker1,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb_docker1,target=/data/configdb --mount type=volume,source=mongocerts_docker1,target=/mongocerts --mount type=volume,source=mongologs_docker1,target=/var/log/mongodb --constraint 'node.hostname == docker1' --name mongo3 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"
#docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata_docker2,target=/data/db --mount type=volume,source=mongoconf_docker2,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb_docker2,target=/data/configdb --mount type=volume,source=mongocerts_docker2,target=/mongocerts --mount type=volume,source=mongologs_docker2,target=/var/log/mongodb --constraint 'node.hostname == docker2' --name mongo4 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"

CID=$(docker ps -q -f name=mongodb_cluster_server1)

if [ -z "$CID" ]; then
    echo "No container found."
    exit 1
fi

ENTRYPOINT=/home/raychorn/__projects/portainer-ce/docker/mongodb5/swarm_mongoscripts/entrypoint.sh

if [ ! -f "$ENTRYPOINT" ]; then
    echo "Entrypoint script not found."
    exit 1
fi

echo "ENTRYPOINT:$ENTRYPOINT --> $CID:/entrypoint.sh"
docker cp $ENTRYPOINT $CID:/entrypoint.sh

echo "BEGIN: /data/db"
docker exec -it $CID /bin/bash -c "ls -la /data/db"
echo "END!!! /data/db"

docker exec -it -d $CID /bin/bash -c "chmod +x /entrypoint.sh && /entrypoint.sh"

VAR_LIB_DOCKER_VOLUMES=/var/lib/docker/volumes

VOLUME_NAME=mongologs
VOLUME_TEST=$(docker volume ls | grep $VOLUME_NAME)
if [ -z "$VOLUME_TEST" ]; then
    echo "Cannot find volume $VOLUME_NAME so cannot continue."
    exit 1
fi

MOUNTPOINT=$(docker volume inspect $VOLUME_NAME | jq -r '.[0].Mountpoint')
VOLUME_DIR=$VAR_LIB_DOCKER_VOLUMES/$VOLUME_NAME/_data

if [ ! -d "$VOLUME_DIR" ]; then
    echo "Cannot find VOLUME_DIR:$VOLUME_DIR so cannot continue."
    exit 1
fi

#docker run --privileged -v /run/systemd/system:/run/systemd/system -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket -it $CID systemctl

COUNT=0
RUNLOG=$VOLUME_DIR/mongod-daemon.log
while true; do
    COUNT=$((COUNT+1))
    echo "($COUNT) BEGIN: $RUNLOG"
    if [ -f "$RUNLOG" ]; then
        ls -la $RUNLOG
        tail -n 10 $RUNLOG
    fi
    echo "($COUNT) END!!! $VOLUME_DIR"
    TEST=$(docker exec -it $CID /bin/bash -c "ps -aux | grep mongod")
    if [ -z "$TEST" ]; then
        echo "MongoDB is not running yet..."
    fi
    sleep 10
    if [ $COUNT -gt 10 ]; then
        echo "COUNT:$COUNT"
        break
    fi
done