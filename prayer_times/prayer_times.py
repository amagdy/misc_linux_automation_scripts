#!/usr/bin/python
import time
import os.path
import os
from subprocess import call
import re
import urllib2


# Change this URL to match your city make sure that the URL does NOT contain the month and year params
URL = "http://www.islamicfinder.org/prayerPrintable.php?city2=Doha&state=01&id=719&longi=51.5333&lati=25.2867&country2=Qatar&zipcode=&today_date_flag=2015-12-28&changeTime=16&pmethod=4&HanfiShafi=1&dhuhrInterval=1&maghribInterval=1&dayLight=0&dayl=0&timez=3.00&dayLight_self_change=&prayerCustomize=&lang=&fajrTwilight=0&ishaTwilight=0&ishaInterval=0"

PLAYER = "totem"
ATHAN_DIR = "athan"
CHECK_INTERVAL=40


URL += "&month={0}&year={1}"
NUMBER_OF_FIELDS = 9

def getRawPrayerDataByDate(month, year):
	header_pattern = r'Day.*Hijri.*Fajr.*Sunrise.*Dhuhr.*Asr.*Maghrib.*Isha'
	month_url = URL.format(month, year)
	html = urllib2.urlopen(month_url).read()
	html = re.search(r'(<table [^>]* width=475[^>]*>([\d\D]+)<\/TABLE>)', html).group(2)
	html = re.sub(r'(?i)<(?!tr|th|td)[^>]*>[^>]*<\/(?!tr|th|td)>', '', html)
	html = re.sub(r'(?i)<\/tr>', '#####', html)
	html = re.sub(r'(?i)<\/td>', '@@@@@', html)
	html = re.sub(r'<[^>]+>', '', html)
	html = html.replace('&nbsp;', '').strip()
	html = re.sub(r'Day@@@@@[^#]+#####', '', html)
	html = html.replace("\n", '').strip()
	formatted_data = {}
	days = html.split("#####")
	for day in days:
		day_data = day.split("@@@@@")
		if len(day_data) >= NUMBER_OF_FIELDS: 
			prayers = {'fajr': day_data[3], 'shrooq': day_data[4], 'thuhr': day_data[5], 'asr': day_data[6], 'maghrib': day_data[7], 'isha': day_data[8]}
			for key, value in prayers.iteritems():
				prayers[key] = formatTime(value.strip(), key)
			day_hash = {'day_name': day_data[0].strip(), 'day_num': day_data[1].strip(), 'hijri': day_data[2].strip(), 'prayers': prayers}
			formatted_data[str(day_hash['day_num'])] = day_hash
	return formatted_data


def formatTime(hour_minute, prayerName):
	(hour, minute) = hour_minute.split(":")
	hour = int(hour)
	if hour > 0 and hour < 12:
		if prayerName == 'thuhr' and hour < 5:
			hour += 12
		else:
			if prayerName != 'fajr' and prayerName != 'shrooq' and prayerName != 'thuhr':
				hour += 12
	str_time = str(hour) + ":" + minute
	return re.sub(r'^0', '', str_time)


if __name__ == "__main__":
	current_year_month = ""
	current_month_data = {}
	next_prayer = {}

	while True:
		year_month = time.strftime("%Y-%m")
		(year, month) = year_month.split("-")
		if current_year_month != year_month:
			current_year_month = year_month
			current_month_data = getRawPrayerDataByDate(month, year)
		hash_day = current_month_data[time.strftime("%d")]
		prayers = {v: k for k, v in hash_day['prayers'].items()}
		current_time = re.sub(r'^0', '', time.strftime("%H:%M"))
		print prayers
		print current_time
		prayer_name = prayers.get(current_time, "")
		if prayer_name != "":
			athan_file = '{0}/{1}.mp3'.format(ATHAN_DIR, prayer_name)
			prayer_name = prayer_name[:1].upper() + prayer_name[1:]
			os.popen('zenity --info --text "Now is {0} Prayer"'.format(prayer_name))
			if os.path.exists(athan_file):
				os.popen('{0} {1}'.format(PLAYER, athan_file))
		time.sleep(CHECK_INTERVAL)

