#!/bin/bash
WORK_HOURS=$1
if [ -z "$WORK_HOURS" ]; then
  WORK_HOURS="8:0:"
fi

SECONDS=0
TODAY=`date +%Y-%m-%d`
while true
do
  if [ -z "$FILE" ]; then
          TS=`cat ~/stopwatch/scripts/timestamp.txt | awk -vFS="#@#" '{print $1;}'`
          SECONDS=$((`date +%s`-$TS))
          FILE=`cat ~/stopwatch/scripts/timestamp.txt | awk -vFS="#@#" '{print $2;}'`
  fi

  PLUS=$(cat $FILE | grep $TODAY | awk -vFS="###" -vORS="+" '{print $1;}')
  if [ -n "$PLUS" ]; then
          SECONDS=$(($PLUS$SECONDS))
  fi

  function humanize () {
          SECONDS=$1
          H=$(($SECONDS / 3600))
          M=$((($SECONDS - ($H*3600)) / 60))
          S=$((($SECONDS - (($H*3600) + ($M*60))) % 60))
          echo "$H:$M:$S"
  }
  
  X=`humanize $SECONDS`
  if [ -n "`echo $X | grep -E "^$WORK_HOURS"`" ]; then
    notify-send -t 60 "Finished Work"
    exit 0
  else
    if [ -n "`echo $X | grep -E ":[1-5]?0:"`" ]; then
      notify-send -t 10 "Uptime: $X"
    fi
  fi
  sleep 60
done


