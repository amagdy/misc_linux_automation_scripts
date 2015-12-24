#!/bin/bash
### taken from http://www.debian-administration.org/article/A_web_server_in_a_shell_script
base=$1
read request

while true; do
  read header
  [ "$header" == $'\r' ] && break;
done
url="${request#GET }"
url="${url% HTTP/*}"
if [ $url == "/" ]; then url="/index.html"; fi 
filename="$base$url"

if [ -f "$filename" ]; then
  if [[ "$filename" =~ "$base/commands/" ]]; then
  	$filename 2&> /dev/null &
  	echo -e "HTTP/1.1 200 OK\r"
	  echo -e "Content-Type: text/html\r"
	  #echo -e "Content-Type: `/usr/bin/file -bi \"$filename\"`\r"
	  echo -e "\r"
	  cat "$base/done.html"
	  echo -e "\r"
  else
	  echo -e "HTTP/1.1 200 OK\r"
	  echo -e "Content-Type: text/html\r"
	  #echo -e "Content-Type: `/usr/bin/file -bi \"$filename\"`\r"
	  echo -e "\r"
	  cat "$filename"
	  echo -e "\r"
  fi
else
  echo -e "HTTP/1.1 404 Not Found\r"
  echo -e "Content-Type: text/html\r"
  echo -e "\r"
  echo -e "404 Not Found\r"
  echo -e "Not Found
	       The requested resource was not found\r"
  echo -e "\r"
fi
