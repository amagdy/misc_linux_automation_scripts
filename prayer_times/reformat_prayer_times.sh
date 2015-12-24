#!/bin/bash
function date_time_to_ts {
	INDATE=$1
	DAY=$(echo $INDATE | awk '{print $1;}')
	MONTH=$(echo $INDATE | awk '{print $2;}')
	YEAR=$(echo $INDATE | awk '{print $3;}')
	declare -A ALL_MONTHS=(["Jan"]="1" ["Feb"]="2" ["Mar"]="3" ["Apr"]="4" ["May"]="5" ["Jun"]="6" ["Jul"]="7" ["Aug"]="8" ["Sep"]="9" ["Oct"]="10" ["Nov"]="11" ["Dec"]="12")
	MONTH=${ALL_MONTHS["$MONTH"]}
	TS=$(date -d "$YEAR"/"$MONTH"/"$DAY $2" "+%s")
	echo $TS" "$INDATE" "$2" "$4"   "$3
}

#cat salah.txt | while read l; do 


cat $1 | while read LINE
do
	# 20 Jun 2014	٢٢ شعبان ١٤٣٥ هـ	03:12 am	04:44 am	11:36 am	02:58 pm	06:27 pm	07:57 pm
	DATE=$(echo $LINE | awk '{print $1" "$2" "$3;}')
	HIJRI=$(echo $LINE | awk '{print $4" "$5" "$6" "$7;}')
	FAJR=$(echo $LINE | awk '{print $8" "$9;}')
	SHROOK=$(echo $LINE | awk '{print $10" "$11;}')
	DHUHR=$(echo $LINE | awk '{print $12" "$13;}')
	ASR=$(echo $LINE | awk '{print $14" "$15;}')
	MAGHREB=$(echo $LINE | awk '{print $16" "$17;}')
	ISHAA=$(echo $LINE | awk '{print $18" "$19;}')
	
	date_time_to_ts "$DATE" "$FAJR" "$HIJRI" "Fajr"
	date_time_to_ts "$DATE" "$SHROOK" "$HIJRI" "Shrook"
	date_time_to_ts "$DATE" "$DHUHR" "$HIJRI" "Dhuhr"
	date_time_to_ts "$DATE" "$ASR" "$HIJRI" "Asr"
	date_time_to_ts "$DATE" "$MAGHREB" "$HIJRI" "Maghreb"
	date_time_to_ts "$DATE" "$ISHAA" "$HIJRI" "Ishaa"
done > "formatted.txt"
