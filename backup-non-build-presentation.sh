#!/bin/bash
mainserver=XXXXXX
bbb-record --list | grep "^.\{128\} " | cut -b 1-54 >> list.txt
filename='list.txt'
while read p; do 
  rsync -a /var/bigbluebutton/recording/raw/${p} root@${mainserver}:/mnt/scalelite-recordings/var/bigbluebutton/backup-raw
done < $filename
rm list.txt
