#!/bin/bash

sudo find / -type f -size +50000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
