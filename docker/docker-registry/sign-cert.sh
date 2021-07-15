#!/bin/bash

sudo openssl x509 -in ./certs/request.csr -out ./certs/certificate.crt -req -signkey ./certs/private.key -days 99999
