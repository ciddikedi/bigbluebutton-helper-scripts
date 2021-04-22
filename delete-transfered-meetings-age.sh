#!/bin/bash

MAXAGE=15
shopt -s nullglob
NOW=$(date +%s)

for donefile in /var/bigbluebutton/recording/scalelite/copied/* ; do
        MTIME=$(stat -c %Y "${donefile}")
        if [ $(( ( $NOW - $MTIME ) / 86400 )) -gt $MAXAGE ]; then
                MEETING_ID=$(basename "${donefile}")
                rm -rf /var/bigbluebutton/published/presentation/${MEETING_ID}
        fi
done
