#!/usr/bin/php
<?php
require_once(dirname(__FILE__) . '/inc.php');

$time_stamp_file = dirname(__FILE__) . "/timestamp.txt";

if (file_exists($time_stamp_file)) {
	log_error ('Time stamp file [' . $time_stamp_file . '] already exists');
}

$log_file = $argv[1];
if (!$log_file) $log_file = trim(`zenity --file-selection`);
if (!$log_file || !file_exists($log_file)) {
	log_error ('Log File [' . $log_file . '] does not exist');
}

file_put_contents($time_stamp_file, time() . "#@#" . $log_file);

make_launcher(dirname(__FILE__), trim(`echo ~/Desktop/Stop.desktop`), "stop.sh", "stop.png", "Stop", "Stop the stopwatch");

