#!/bin/bash

docker swarm init --advertise-addr $(hostname -i) --listen-addr 0.0.0.0:2377
