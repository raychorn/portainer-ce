#!/usr/bin/env bash

docker volume create --name nginx1_conf_volume --opt type=none --opt device=/etc/nginx --opt o=bind
