#!/usr/bin/bash

while [ true ]; do
    ssh -NL 12375:10.0.0.196:2375 -i "~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase" ubuntu@10.0.0.196
done

