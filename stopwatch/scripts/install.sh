#!/usr/bin/php
<?php
require_once(dirname(__FILE__) . '/inc.php');

make_launcher(dirname(__FILE__), trim(`echo ~/Desktop/Start.desktop`), "start.sh", "start.png", "Start", "Start the stopwatch");
make_launcher(dirname(__FILE__), trim(`echo ~/Desktop/Format.desktop`), "format.sh", "format.png", "Format", "Format a log file to generate the minutes timelog file");

