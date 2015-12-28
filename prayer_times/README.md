## Prayer Times
This script fetches the prayer times from IslamicFinder.com and plays Athan on the prayer time.

### Installation
Download the code and put it in a folder and put beside it another folder that contains the athan mp3 files:

prayer_times/prayer_times.py
prayer_times/athan/fajr.mp3
prayer_times/athan/shrooq.mp3
prayer_times/athan/thuhr.mp3
prayer_times/athan/asr.mp3
prayer_times/athan/maghrib.mp3
prayer_times/athan/isha.mp3

If you want to mute one prayer you can remove its file.
If you would like to change the location of athan files just the the constant ATHAN_DIR to another path.

Install  zenity for the dialogs to appear:
	sudo apt-get install zenity totem

**N.B.**
You can set the player that you wish by setting the constant: PLAYER

**Set the URL to pull the prayer times**
Navigate to the corresponding link for the monthly prayer times of your city in Islamicfinder.com 
Here is an example for Doha, Qatar
http://www.islamicfinder.org/prayerDetail.php?country=qatar&city=Doha&state=01&id=719&month=&year=&email=&home=2015-12-28&lang=&aversion=&athan=&monthly=1

Then click on the right button of "Monthly Schedule" which will open a print friendly version like this:
http://www.islamicfinder.org/prayerPrintable.php?city2=Doha&state=01&id=719&longi=51.5333&lati=25.2867&country2=Qatar&zipcode=&today_date_flag=2015-12-28&changeTime=16&pmethod=4&HanfiShafi=1&dhuhrInterval=1&maghribInterval=1&dayLight=0&dayl=0&timez=3.00&dayLight_self_change=&prayerCustomize=&lang=&fajrTwilight=0&ishaTwilight=0&ishaInterval=0&month=12&year=2015

remove the month and the year attributes from the end of the URL and set it in the URL constant on the top of the file

**Run at Startup**
Make this script run at startup and it will be running all the time to remind you about prayers


### Future work:
Create an Islamic crontab where you can set any job to run with respect to prayer times or Hijri calendar

