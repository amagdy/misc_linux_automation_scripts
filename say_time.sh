#!/bin/bash
# This script says the current time using text to speech and adds some Arabic humor at the end
# usage: ./say_time.sh
# N.B. make sure that "festival" is installed

HOURS24=`date '+%k'`
HOURS24=$(($HOURS24+0))

HOURS=`date '+%l'`
MINUTES=`date '+%M' | sed 's/^0//'`

echo "Ahmaad?" | festival --tts
sleep 0.5
if [ $HOURS24 -lt 12 ] && [ $HOURS24 -gt 4 ]; then
	echo "Good Morning?" | festival --tts
elif [ $HOURS24 -lt 17 ] && [ $HOURS24 -gt 11 ]; then
	echo "Good After noon?" | festival --tts
elif [ $HOURS24 -lt 20 ] && [ $HOURS24 -gt 16 ]; then
	echo "Good Evening?" | festival --tts
else
	echo "Good Night?" | festival --tts
fi

sleep 0.5
if [ "$MINUTES" -eq "0" ]; then
	echo "it's $HOURS oclock" | festival --tts
else
	echo "it's $HOURS oclock and $MINUTES minutes" | festival --tts
fi

sleep 1
echo "maafeeesh shokraaan?" | festival --tts
sleep 0.7
echo "el afw yaa haabeeeeby?" | festival --tts

