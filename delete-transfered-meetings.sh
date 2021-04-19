#!/bin/bash
FILES=/var/bigbluebutton/recording/scalelite/copied/*
LENGTH=${#FILES}-1
for f in $FILES
do
  f="${f:LENGTH}"
  echo $f "found"
  rm -rf /var/bigbluebutton/published/presentation/$f
done
