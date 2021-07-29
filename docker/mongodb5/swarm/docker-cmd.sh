#!/usr/bin/env bash

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.initiate({ _id: "rs0", members: [{ _id: 1, host: "10.0.0.139:27017" }, { _id: 2, host: "10.0.0.179:27017" }, { _id: 3, host: "10.0.0.239:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.status()'

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.config()'
