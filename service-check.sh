#!/bin/bash

# ./service-check.sh $DAEMON_NAME
# running : 1, not running : 0 return.


if [ -z $1 ]; then
    echo "proceess not found."
    exit 1
fi

PROCESS="$1"
PID="/var/run/$1"

if [ -f "$PID" ]
then
        PROCPID=`service $PROCESS status | awk '{print $3}' | sed 's/)//g'`
        ALIVECHK=`service $PROCESS status | grep -c $PROCPID`
        echo "$ALIVECHK";
        exit
        #echo "PROCPID - $PROCPID"
else
        PROC2PID=`ps -ef | pgrep ${PROCESS:0:14}`
        if [ -z "$PROC2PID" ]; then
                echo "0 ($PROCESS) Process daemon not found."
            exit 1;
        fi
        ALIVECHK=`cat /proc/$PROC2PID/status | grep Name | sed 's/Name://g' | grep -c "${PROCESS:0:14}"`
fi

        echo "$ALIVECHK"
exit
