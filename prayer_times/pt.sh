#!/bin/bash
URL="http://www.islamicfinder.org/prayerDetail.php?latitude=45.4386&longitude=12.3267&timezone=1&pmethod=1&fajrTwilight1=10&ishaTwilight=10&fajrTwilight2=10&ishaInterval=30&HanfiShafi=1&dhuhrInterval=1&maghribInterval=1&id=32318&daylight=1&prayerCustomize=1&city=venice&state=20&state_name=Veneto&zipcode=&country=italy&athan=&aversion=&lang="
DATE=$1
if [ -z "$DATE" ]; then
	DATE=$(date '+%Y/%m/%d')
fi
YEAR=$(echo $DATE | awk '{print $1;}')
MONTH=$(echo $DATE | awk '{print $2;}')
DAY=$(echo $DATE | awk '{print $3;}')
URL=$URL"&day=$DAY&month=$MONTH&year=$YEAR"

curl "$URL" -s | grep -A 1000 -E "Prayer Schedule" | grep -B 1000 -E "Annual Schedule" | sed 's/<td class="IslamicData" bgcolor="#FFFF[FC][FC]" align="center">//g; s/<\/td>//g' | awk -vORS="###" '{print $0;}' | sed 's/<\/tr>[# ]*<tr>/@@@/g' | awk -vFS="###" -vORS="\n" -vRS="@@@" '{print $2" "$3" "$4" "$5" "$6" "$7" "$8" "$9;}' | head -9 | tail -7
