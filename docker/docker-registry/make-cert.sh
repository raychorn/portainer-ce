#!/bin/bash

sudo openssl req -nodes -newkey rsa:2048 -keyout ./certs/private.key -out ./certs/request.csr
