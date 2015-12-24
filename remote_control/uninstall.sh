#!/bin/bash

HOME_DIR=$(pwd)

# stop server
$HOME_DIR/stop_server.sh

# remove start script
rm $HOME_DIR/remote_control_server.sh

#remove from startup
sudo rm /etc/rc2.d/S99remote_control_server
sudo rm $HOME_DIR/lib/input
