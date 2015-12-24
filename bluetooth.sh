#!/bin/bash
NEW_FILE_NAME=`echo $1 | awk -vFS="/" '{print $NF;}'`
ussp-push 00:22:65:89:22:E6@9 "$1" "$NEW_FILE_NAME"
