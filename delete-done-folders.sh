#!/bin/bash
FILES=/var/bigbluebutton/recording/status/published/*
LENGTH=${#FILES}-1
for f in $FILES
do
  f="${f:LENGTH}"
  echo $f "found"
  f="${f::-18}"
  rm -rf /var/bigbluebutton/$f
done
