#!/bin/bash
LOG_FILE=""
LOG_DIR=""
LOCK_FILE=""



function setup () {
	LOG_DIR="$HOME/Desktop/magdy_screen_watcher"
	LOG_FILE="$LOG_DIR/`date '+%d_%m_%Y'`.log"
	LOCK_FILE="$LOG_DIR/`date '+%d_%m_%Y'`.lock"
	if [ ! -d "$LOG_DIR" ]; then
		mkdir "$LOG_DIR"
	fi
	touch $LOG_FILE
}

setup


function humanize_seconds () {
	HOURS=$(($1/3600))
	MIN=$((($1%3600)/60));
	SEC=$(($1%60));
	echo "`printf %02d $HOURS`:`printf %02d $MIN`:`printf %02d $SEC`"
}

function openned_screen () {
	DIFF=$((`date '+%s'` - `cat $LOCK_FILE | head -1`))
	rm $LOCK_FILE
	echo "<IDLE> `humanize_seconds $DIFF`" >> $LOG_FILE
	/usr/bin/purple-remote "setstatus?status=available&message="
}

function closed_screen () {
	date '+%s' > $LOCK_FILE
	#echo "<closed> `date`" >> $LOG_FILE
	/usr/bin/purple-remote "setstatus?status=away&message=Having a walk"
}

while true; do 
	OPEN=1
	while [ "`gnome-screensaver-command --query | head -1`" = "The screensaver is active" ]; do
		if [ $OPEN == 1 ]; then closed_screen; fi
		OPEN=0
		sleep 5
	done
	if [ $OPEN == 0 ]; then openned_screen; fi
	sleep 5
done


