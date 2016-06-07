#!/bin/bash

ps aux | grep "blockdev --getsize64 /dev/sd*" | awk '{print $13}' >~/hlog.txt

FILE=~/hlog.txt

if [ -f $FILE ];
then
echo "Scanning $FILE ..."
cnt=$(cat $FILE  | wc -l)
if [ $cnt -gt 3 ] ;
then
echo "Problem identified on $HOSTNAME... More than 3 returns... Sending alert emails..."
echo "### Please Check $HOSTNAME. The above drive(s) are causing blockdev errors. Recommend Disk Replacement, Reboot if needed ###" >> $FILE
echo "Subject: Problem on $HOSTNAME" | cat - $FILE | sendmail -F "$HOSTNAME" -t name@email.com
fi
else
echo "System looks good captian"
fi