#!/bin/bash

DIR=$1
if [ -z "$1" ]; then
	DIR=$(dirname $0)
fi

INPUT_FILE=$DIR"/formatted.txt"
ATHAN_FILE=$DIR"/athan.mp3"
NEXT_PRAYER_FILE=/tmp/prayer_time.$$

function find_next_prayer {
	TS=$(date '+%s')
	cat $1 | while read l
	do
		PRAYER_TS=$(echo $l | awk '{print $1;}')
		if [[ $PRAYER_TS -gt $TS ]]; then
			echo $l
			exit 0
		fi
	done
	exit 1
}

echo $NEXT_PRAYER_FILE
echo "========================="

while true
do
	if [ ! -e $NEXT_PRAYER_FILE ]; then
		NEXT_PRAYER=$(find_next_prayer $INPUT_FILE)
		echo $NEXT_PRAYER > $NEXT_PRAYER_FILE
		echo $NEXT_PRAYER | awk '{print  "Next Prayer: "$7" "$5" "$6;}'
	else
		NEXT_PRAYER=$(cat $NEXT_PRAYER_FILE)
	fi
	PRAYER_TS=$(echo $NEXT_PRAYER | awk '{print $1;}')
	TS=$(date '+%s')
	if [[ $PRAYER_TS -lt $TS ]]; then
		MSG=$(echo $NEXT_PRAYER | awk '{print  "Pray Now: "$7" "$5" "$6;}')
		totem $ATHAN_FILE 2&> /dev/null &
		echo $MSG
		zenity --info --title="Athan" --text="$MSG"
		NEXT_PRAYER=$(find_next_prayer $INPUT_FILE)
		echo $NEXT_PRAYER > $NEXT_PRAYER_FILE
		echo $NEXT_PRAYER | awk '{print  "Next Prayer: "$7" "$5" "$6;}'
	fi
	sleep 5
done
