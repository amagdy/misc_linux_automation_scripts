#!/bin/bash
HOME_DIR=$(pwd)
echo -e "#!/bin/bash\nHOME_DIR="$HOME_DIR"\n" > remote_control_server.sh
cat lib/remote_control_server_template.bk >> remote_control_server.sh
chmod +x remote_control_server.sh
chmod +x stop_server.sh
chmod +x uninstall.sh


# install in startup
echo "#! /bin/sh" > /tmp/S99remote_control_server
echo "$HOME_DIR/remote_control_server.sh" >> /tmp/S99remote_control_server
sudo mv /tmp/S99remote_control_server /etc/rc2.d/S99remote_control_server
sudo chmod +x /etc/rc2.d/S99remote_control_server
