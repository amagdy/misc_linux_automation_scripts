#!/bin/bash
. config

ps aux | grep bash | grep remote_control_server.sh | grep -v grep | awk '{print $2;}' | while read l; do sudo kill -9 $l; done
ps aux | grep "nc -l "$PORT | grep -v grep | awk '{print $2;}' | while read l; do sudo kill -9 $l; done
ps aux | grep handle_request.sh | grep bash | grep -v grep | awk '{print $2;}' | while read l; do sudo kill -9 $l; done
