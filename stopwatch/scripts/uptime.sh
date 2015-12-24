#!/usr/bin/php
<?php
require_once(dirname(__FILE__) . '/inc.php');

$time_stamp_file = dirname(__FILE__) . "/timestamp.txt";

if (!file_exists($time_stamp_file)) {
	log_error ("Timestamp file is missing");
}
$time = file_get_contents($time_stamp_file);
$arr_time = split("#@#", $time);
$elapsed_time = time() - $arr_time[0];


$today_duration = time_array_to_string(humanize_seconds($elapsed_time));

`zenity --info --title="Uptime" --text="        $today_duration             "`;

