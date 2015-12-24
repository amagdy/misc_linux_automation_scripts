#!/bin/bash
# This script exports the Skype history every hour to a text file 
# You can use it with a full text search engine to search your Skype history easily

SEVEN_DAYS_AGO=$(($(date -d $(date '+%Y-%m-%d') '+%s')-432000))
sqlite3 ~/.Skype/a1works/main.db <<!
.dump csv
.output skype.csv
SELECT "<######>"||timestamp, from_dispname, dialog_partner, body_xml FROM Messages WHERE timestamp >= $SEVEN_DAYS_AGO;
!

mv skype.csv ./Skype_Conversations/
cd Skype_Conversations/

FILENAME=""
cat skype.csv | while read l
do
	echo -n $l"<##newline##>"
done > skype_formatted.csv

cat skype_formatted.csv | awk -vRS="<######>" '{print $0;}' | while read l
do
	if [ -n "$l" ] && [ -z "$(echo $l | grep '<partlist')" ]; then
		RECORD_DATE=$(date -d @$(echo $l | awk -vFS="|" '{print $1;}'))	
		AUTHOR=$(echo $l | awk -vFS="|" '{print $2;}')
		TO_USER=$(echo $l | awk -vFS="|" '{print $3;}')
		TEXT=$(echo $l | awk -vFS="|" '{print $4;}')
		if [ -z "$TEXT" ] || [ "$TEXT" == "<##newline##>" ]; then continue; fi
		FILENAME=$(echo $RECORD_DATE | awk '{print $NF"-"$2"/skype_messages___"$NF"-"$2"-"$3".tmp";}')
		FOLDERNAME=$(echo $FILENAME | awk -vFS='/' '{print $1;}')
		if [ ! -d "$FOLDERNAME" ]; then
			mkdir -p $FOLDERNAME
		fi
		echo $RECORD_DATE"  |  "$AUTHOR" to "$TO_USER" :" 									>> $FILENAME
		echo $TEXT | sed 's/<##newline##>/\n/g ; s/&quot;/"/g ; s/&apos;/\x27/g' >> $FILENAME
		echo -e "\n====================================================\n" 	>> $FILENAME
	fi
done

find ./ -name *.tmp | while read l; do
	mv $l $(echo $l | sed 's/\.tmp/.txt/g')
done

rm skype.csv skype_formatted.csv

