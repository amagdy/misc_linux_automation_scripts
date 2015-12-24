#!/bin/bash

function is_next_prayer {
	DATE_TIME_OF_PRAYER=$1
	PRAYER_NAME=
}

function format_date {
	DATE=$1
	TIME=$2
	date -d "$DATE $TIME" '+%Y/%m/%d %I:%M%p'
}

function line_for_date {
	DATE=$1
	LINE=$(ipraytime --latitude 25.2695 --longitude 51.5167 -sea 13 --fajrangle 18.4 -b -u 3.03 --date $(echo $DATE | sed 's/\///g')  | tail -1)
	FAJR=$(echo $LINE | awk '{print $2;}')
	SHROOK=$(echo $LINE | awk '{print $3;}')
	THUHR=$(echo $LINE | awk '{print $4;}')
	ASR=$(echo $LINE | awk '{print $5;}')
	MAGHREB=$(echo $LINE | awk '{print $6;}')
	ISHAA=$(echo $LINE | awk '{print $7;}')
	echo $(date -d "$DATE $FAJR" '+%s')" Fajr "$(format_date $DATE $FAJR)
	echo $(date -d "$DATE $SHROOK" '+%s')" Shrook "$(format_date $DATE $SHROOK)
	echo $(date -d "$DATE $THUHR" '+%s')" Thuhr "$(format_date $DATE $THUHR)
	echo $(date -d "$DATE $ASR" '+%s')" Asr "$(format_date $DATE $ASR)
	echo $(date -d "$DATE $MAGHREB" '+%s')" Maghreb "$(format_date $DATE $MAGHREB)
	echo $(date -d "$DATE $ISHAA" '+%s')" Ishaa "$(format_date $DATE $ISHAA)
}


function format_dates {
	LINE=$1
	FAJR=$(echo $LINE | awk '{print $2;}')
	SHROOK=$(echo $LINE | awk '{print $3;}')
	THUHR=$(echo $LINE | awk '{print $4;}')
	ASR=$(echo $LINE | awk '{print $5;}')
	MAGHREB=$(echo $LINE | awk '{print $6;}')
	ISHAA=$(echo $LINE | awk '{print $7;}')
	
}

function get_prayer_times {
	DATE1=$(date '+%Y/%m/%d')
	TS=$(($(date '+%s')+86400))
	DATE2=$(date -d @$TS '+%Y/%m/%d')
	
	line_for_date $DATE1
	line_for_date $DATE2
	
}

get_prayer_times

function find_next_prayer {
	
	DATE=$(echo $LINE | awk '{print $1;}' | sed 's/\[//g; s/\]//g')
	DATE=$(echo $DATE | awk -vFS="-" '{print $3;}')"/"$(echo $DATE | awk -vFS="-" '{print $2;}')"/"$(echo $DATE | awk -vFS="-" '{print $1;}')
	
	FAJR=$(echo $LINE | awk '{print $2;}')
	SHROOK=$(echo $LINE | awk '{print $3;}')
	THUHR=$(echo $LINE | awk '{print $4;}')
	ASR=$(echo $LINE | awk '{print $5;}')
	MAGHREB=$(echo $LINE | awk '{print $6;}')
	ISHAA=$(echo $LINE | awk '{print $7;}')
	
	
}
#DATE_TIME=$()
#echo $DATE
#date -d "$DATE $ISHAA"
