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
$log_file = $arr_time[1];

$comment = `zenity --entry`;
$output = $elapsed_time . "###" . date('Y-m-d') . '###' . date('H:i:s') . "###" . $comment;


if (!$handle = fopen($log_file, 'a')) {
	log_error("Could not open file (" . $log_file . ") on [" . date('y-m-d H:i:s') . "]");
}

if (fwrite($handle, $output) === FALSE) {
	log_error("Could not write to file (" . $log_file . ") on [" . date('y-m-d H:i:s') . "]");
}
fclose($handle);


unlink($time_stamp_file);
`rm ~/Desktop/Stop.desktop`;

$arr_seconds = get_seconds_array_from_file($log_file, date('Y-m-d'));
$arr_total_seconds = get_seconds_array_from_file($log_file);

$session_duration = time_array_to_string(humanize_seconds($arr_seconds[count($arr_seconds)-1]));
$today_duration = time_array_to_string(humanize_seconds(array_sum($arr_seconds)));
$total_duration = time_array_to_string(humanize_seconds(array_sum($arr_total_seconds)));

$msg = "Worked Hours in this Session:     " . $session_duration;
$msg .= "\n\nWorked Hours in Today:       " . $today_duration;
$msg .= "\n\nTotal Hours:                 " . $total_duration;

$log_file_name_parts = explode('/', $log_file);
$log_file_name = $log_file_name_parts[count($log_file_name_parts)-1];
`zenity --info --title="$log_file_name" --text="$msg"`;

