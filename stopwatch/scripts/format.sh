#!/usr/bin/php5
<?php
require_once(dirname(__FILE__) . '/inc.php');


$ROOT = dirname(__FILE__);
$log_file = trim($argv[1]);
if (!$log_file) $log_file = trim(`zenity --file-selection`);
$var = trim(file_get_contents($log_file));

$arr_lines = split("\n", $var);
if (!$arr_lines) exit();
$output = "";
$sum_seconds = 0;
while (list(, $line) = each($arr_lines)) {
	list($seconds, $date, $time, $comments) = split("###", trim($line));
	$sum_seconds += $seconds;
	$output .= time_array_to_string(humanize_seconds($seconds)) . "\t" . $date . "\t" . $time . "\t" . $comments . "\n";
}
$output .= "SUM = " . time_array_to_string(humanize_seconds($sum_seconds)) . "\n";

$arr_path = pathinfo($log_file);
$minutes_file = trim(`echo ~/Desktop/`) . $arr_path['filename'] . ".timelog";
file_put_contents($minutes_file, $output);

