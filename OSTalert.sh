#!/bin/bash
#sends processor status for uninterruptible hung disks to file hlog.txt (overwrites)
ps aux | grep "blockdev --getsize64 /dev/sd*" | awk '{print $13}' >~/hlog.txt

#sets variables for $FLIE and $cnt (cnt = lines in $FILE)
FILE=~/hlog.txt
cnt=$(cat $FILE | wc -l)

#confirms $FILE exists, checks checks for > 3 process returns, emails alert or gives all clear message
if [ -f $FILE ]; then
  echo "Updating then scanning $FILE..."
if [ $cnt -gt 3 ]; then
  echo "Problem identified on $HOSTNAME... $cnt returns... Sending alert emails..."
  echo "##### Please Check $HOSTNAME. The drive(s) listed below are causing blockdev errors and are uninterruptible. Recommend actions: Disk Replacement ASAP, Reboot if users are reporting Tier3 retrieval errors. #####" | cat - $FILE > temp && mv -f temp $FILE
  echo "Subject: Problem on $HOSTNAME" | cat - $FILE | sendmail -F "$HOSTNAME" -t chaggarty@pac-12.org
else 
  echo "All systems normal!"
fi ;
fi
