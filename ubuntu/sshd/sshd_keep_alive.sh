#!/bin/bash

NUMCONN=$(ss | grep -i ssh | egrep -o "([0-9]{1,3}\.){3}[0-9]{1,3}\:ssh.*([0-9]{1,3}\.){3}[0-9]{1,3}" | wc -l)

PANIC_COUNTER=/tmp/sshd_keep_alive_panic_counter.txt

touch $PANIC_COUNTER

if [ $NUMCONN -ge 1 ]; then
    echo "Number of connections: $NUMCONN"
    echo "SSH is running"
else
    echo "SSH is not running so restarting."
    date >> $PANIC_COUNTER
    TEST2=$(lsb_release -r | egrep -o "[0-9]{1,2}\.[0-9]{1,2}")
    if [ "$TEST2" == "20.04" ]; then
        echo "[3]" >> $LOGFILE
        systemctl start ssh
    else
        echo "[4]" >> $LOGFILE
        service ssh restart
    fi
fi
