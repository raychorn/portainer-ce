#!/bin/bash

# https://www.nosqlclient.com/docs/

# https://dev.to/efe136/how-to-enable-mongodb-authentication-with-docker-compose-2nbp

export MONGO_URL=mongodb://172.17.0.3:27777
docker run -d -p 3000:3000 -v /mnt/e/data/mongoclient:/data/db mongoclient/mongoclient:latest
