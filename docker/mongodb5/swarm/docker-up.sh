#!/usr/bin/env bash

export $(cat ./.env | sed 's/#.*//g' | xargs)

docker service create --limit-cpu "6.0" --limit-memory "1g" --dns "10.0.0.196" --reserve-cpu "1.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata1,target=/data/db --mount type=volume,source=mongoconfig1,target=/data/configdb --constraint 'node.labels.mongo.replica == 1' --name mongo1 mongo:latest mongod --replSet "rs0"

docker service create --limit-cpu "6.0" --limit-memory "1g" --dns "10.0.0.196" --reserve-cpu "1.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata2,target=/data/db --mount type=volume,source=mongoconfig2,target=/data/configdb --constraint 'node.labels.mongo.replica == 2' --name mongo2 mongo:latest mongod --replSet "rs0"

docker service create --limit-cpu "6.0" --limit-memory "1g" --dns "10.0.0.196" --reserve-cpu "1.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata3,target=/data/db --mount type=volume,source=mongoconfig3,target=/data/configdb --constraint 'node.labels.mongo.replica == 3' --name mongo3 mongo:latest mongod --replSet "rs0"

docker service ls

./docker-cmd.sh
