#!/bin/bash
FILE=$1
DAYS=$(cat $FILE | awk -vFS="###" '{print $2;}' | sort | uniq | wc -l)
SECONDS=$(cat $FILE | awk -vFS="###" '{print $1;}' | sum)
echo $(($SECONDS/$DAYS))
