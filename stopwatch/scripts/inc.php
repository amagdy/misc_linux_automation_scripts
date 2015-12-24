<?php
function make_launcher ($working_directory, $launcher_file_path, $source_script_name, $launcher_icon_file_name, $name, $comment) {
	$output = "#!/usr/bin/env xdg-open\n\n";
	$output .= "[Desktop Entry]\n";
	$output .= "Encoding=UTF-8\n";
	$output .= "Version=1.0\n";
	$output .= "Type=Application\n";
	$output .= "Terminal=false\n";
	$output .= "Icon[en_US]=gnome-panel-launcher\n";
	$output .= "Name[en_US]=$name\n";
	$output .= "Exec=$working_directory/$source_script_name\n";
	$output .= "Comment[en_US]=$comment\n";
	$output .= "Name=$name\n";
	$output .= "Comment=$comment\n";
	$output .= "Icon=$working_directory/$launcher_icon_file_name\n";
	
	file_put_contents($launcher_file_path, $output);
	
	`chmod +x $launcher_file_path`;
}

function log_error ($message, $title="Error") {
	`zenity --error --text "$message" --title "$title"`;
	exit();
}



function pad_num ($num) {
	return str_pad ($num, 2, "0", STR_PAD_LEFT);
}

function humanize_seconds ($seconds) {
	$arr_out = array();
	$arr_out['hours'] = pad_num(intval($seconds / 3600));
	$arr_out['minutes'] = pad_num(intval(($seconds % 3600) /60));
	$arr_out['seconds'] = pad_num($seconds % 60);
	return $arr_out;
}

function time_array_to_string (array $arg_arr_time_array) {
	return $arg_arr_time_array['hours'] . ":" . $arg_arr_time_array['minutes'] . ":" . $arg_arr_time_array['seconds'];
}


function get_seconds_array_from_file ($arg_file_path, $arg_date='') {
	$lines = file_get_contents($arg_file_path);
	$lines = explode("\n", $lines);
	$arr_seconds = array();
	$arg_date = trim($arg_date);
	while (list(, $line) = each($lines)) {
		$line_parts = explode('###', $line);
		if ($arg_date) {
			if (trim($line_parts[1]) == $arg_date) $arr_seconds[] = $line_parts[0];
		} else {
			$arr_seconds[] = $line_parts[0];
		}
	}
	return $arr_seconds;
}

