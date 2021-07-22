#!/bin/bash

# https://gist.github.com/raychorn/1075e0a4e73c7fb3aaa9400e23805522

docker run -d -p 9000:9000 --cpus="1" --memory=512m --name portainer --restart=always -v portainer_data:/data portainer/portainer-ce -H tcp://host.docker.internal:2375
