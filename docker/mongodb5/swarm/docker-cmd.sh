#!/usr/bin/env bash

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.initiate({ _id: "rs0", members: [{ _id: 1, host: "server-jj95enl.web-service.org:27017" }, { _id: 2, host: "tp01-2066.web-service.org:27017" }, { _id: 3, host: "server1.web-service.org:27017" }], settings: { getLastErrorDefaults: { w: "majority", wtimeout: 30000 }}})'

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.status()'

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.config()'

docker exec -it $(docker ps -qf label=com.docker.swarm.service.name=mongo1) mongo --eval 'rs.status()'

