#!/bin/bash

#docker stack deploy -c portainer-agent-stack.yml portainer

docker run -d -p 8001:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

docker network create --driver overlay --attachable portainer_agent_network

docker service create --name portainer_agent --network portainer_agent_network --publish mode=host,target=9001,published=9001 -e AGENT_CLUSTER_ADDR=tasks.portainer_agent --mode global --mount type=bind,src=//var/run/docker.sock,dst=/var/run/docker.sock --mount type=bind,src=//var/lib/docker/volumes,dst=/var/lib/docker/volumes --mount type=bind,src=/,dst=/host portainer/agent

#docker run -d -p 9001:9001 --name portainer_agent --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/volumes:/var/lib/docker/volumes portainerci/agent:develop

#docker run -d -p 9001:9001 --name portainer_agent --restart=always -v .\pipe\docker_engine:.\pipe\docker_engine portainerci/agent:develop