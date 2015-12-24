#!/bin/bash

function make_launcher () {
	launcher_file_path=$1
	source_script_path=$2
	name=$3
	comment=$4
	chmod +x $source_script_path
	echo "#!/usr/bin/env xdg-open\n" > "$launcher_file_path"
	echo "[Desktop Entry]" >> "$launcher_file_path"
	echo "Encoding=UTF-8" >> "$launcher_file_path"
	echo "Version=1.0" >> "$launcher_file_path"
	echo "Type=Application" >> "$launcher_file_path"
	echo "Terminal=false" >> "$launcher_file_path"
	echo "Icon[en_US]=gnome-panel-launcher" >> "$launcher_file_path"
	echo "Name[en_US]=$name" >> "$launcher_file_path"
	echo "Exec=$source_script_path" >> "$launcher_file_path"
	echo "Comment[en_US]=$comment" >> "$launcher_file_path"
	echo "Name=$name" >> "$launcher_file_path"
	echo "Comment=$comment" >> "$launcher_file_path"
	echo "Icon=" >> "$launcher_file_path"
	
	chmod 0755 $launcher_file_path
}

num=$(echo $$)
folder=$(dirname $1)
filename=$(echo $1 | awk -vFS="/" '{print $NF;}')
launcher_name=$2
comment=$3
if [ -z "$launcher_name" ]; then launcher_name="$filename"; fi
if [ -z "$comment" ]; then comment="My_Comment"; fi
make_launcher "$HOME/Desktop/$num.desktop" $1 "$launcher_name" "$comment"
