#!/usr/bin/env bash

PWD=$(pwd)
SOURCE=/source
DEST=/workspaces
VOLUME=cloudns_refresher_volume

docker volume create -d local -o o=bind -o device=/srv/$VOLUME --name $VOLUME

DIRNAME=code
docker run --rm -v $PWD:$SOURCE -v $VOLUME:$DEST -w $SOURCE alpine cp -R $DIRNAME $DEST/python_runner

FILE=makevenv.sh
docker run --rm -v $PWD:$SOURCE -v $VOLUME:$DEST -w $SOURCE alpine cp $FILE $DEST

FILE=requirements.txt
docker run --rm -v $PWD:$SOURCE -v $VOLUME:$DEST -w $SOURCE alpine cp FILE $DEST
