#!/bin/bash

docker volume create python_runner_volume
sudo cp -p /mnt/e/OneDrive/##projects/#cloudns/cloudns-python/WindowsDynURL/dynamic-url-python.py /var/lib/docker/volumes/python_runner_volume/_data
