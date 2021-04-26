#!/bin/bash
bbb-record --list | grep "^.\{128\} " | cut -b 1-54 >> list.txt
filename='list.txt'
while read p; do 
  bbb-record --rebuild ${p}
done < $filename
rm list.txt
