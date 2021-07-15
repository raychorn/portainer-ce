#!/bin/bash

sudo docker run --entrypoint htpasswd httpd:2 -Bbn raychorn sisko@7660$boo > /opt/docker_registry/auth/htpasswd

sudo htpasswd /opt/docker_registry/auth/.htpasswd raychorn
