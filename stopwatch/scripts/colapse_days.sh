#!/usr/bin/php
<?php
$content = file_get_contents($argv[1]);
$output = "";
$arr_lines = split("\n", $content);
if (!$arr_lines) exit();

$last_date = "";
$day_seconds = 0;
$arr_comments = array();
$last_time = "";
for ($i=0; $i < count($arr_lines); $i++) {
	
	list($seconds, $date, $time, $comment) = split('###', $arr_lines[$i]);
	if (!$last_date) $last_date = $date;
	if ($last_date != $date) {
		$output .= "$day_seconds###$last_date###$last_time###" . join(" & ", $arr_comments) . "\n";
		$day_seconds = 0;
		$arr_comments = array();
	}
	$last_date = $date;
	$last_time = $time;
	$day_seconds += $seconds;
	if (trim($comment)) $arr_comments[] = trim($comment);
	
	if (!$arr_lines[$i+1]) {
		$output .= "$day_seconds###$last_date###$last_time###" . join(" & ", $arr_comments) . "\n";
		break;
	}
}
print $output;
