#!/usr/bin/env bash

docker-compose -f docker-compose-server1.yml up -d

#docker stack deploy -c docker-compose-server1.yml mongodb5

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

echo "Waiting for the build to complete."
sleep 30

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
    echo "(***) TEST:$TEST"
    if [ -z "$TEST" ]; then
        echo "MongoDB is not running yet..."
    else
        echo "MongoDB is running..."
        docker exec -it $CID mongo --eval "rs.initiate({_id: 'rs0', members: [{_id: 0, host: '127.0.0.1:27017'}]});"
        break
    fi
    sleep 15
    if [ $COUNT -gt 20 ]; then
        echo "COUNT:$COUNT"
        break
    fi
done

#    MONGO_TEST=$(ps -aux | grep mongod)
#
#    if [ -z "$MONGO_TEST" ]; then
#        echo "Starting MongoDB ($MONGOD)..." >> $RUNLOG
#        nohup $MONGOD --bind_ip_all --auth --config /etc/mongod.conf --keyFile /mongocerts/keyfile.txt --replSet rs0 >> $RUNLOG 2>&1 &
#
#        echo "Sleeping while the database settles." >> $RUNLOG
#        sleep 15
#
#        echo "re.initiate()" >> $RUNLOG
#        mongo --eval "rs.initiate({_id: 'rs0', members: [{_id: 0, host: '127.0.0.1:27017'}]});"
#    fi
