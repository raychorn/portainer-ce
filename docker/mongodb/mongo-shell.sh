#!/bin/bash

export $(cat ./.env | sed 's/#.*//g' | xargs)

IP=$(hostname -I)

#mongo "mongodb://10.0.0.173:27017" --verbose --username admin --password --authenticationDatabase admin

mongo "mongodb://10.0.0.173:27017" --username admin --password --authenticationDatabase admin
