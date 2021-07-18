#!/bin/bash

#docker-compose -H tcp://host.docker.internal:2375 up -d --force-recreate
docker stack deploy -c portainer-agent-stack.yml portainer
