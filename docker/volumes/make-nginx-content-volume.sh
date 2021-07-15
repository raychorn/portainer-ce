#!/usr/bin/env bash

docker volume create --name nginx1_content_volume --opt type=none --opt device=/home/raychorn/projects/portainer-ce/docker/nginx-content --opt o=bind
