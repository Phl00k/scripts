#!/bin/bash
$lockfile=/tmp/lock.file

if [ ! -e $lockfile ]; then
   touch $lockfile
   . /root/scripts/alert.sh
   rm $lockfile
else
   echo "script already running..."
fi
