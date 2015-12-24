#!/bin/bash
echo -n "Domain: "
read DOMAIN
echo -n "Username: "
read USER

SSH_DIR=~/.ssh
if [ ! -e $SSH_DIR ]
then
	mkdir $SSH_DIR
fi
cd $SSH_DIR
ID_FILE="id_rsa.pub"
if [ ! -e $ID_FILE ]
then 
	ssh-keygen -t rsa
fi

if [ "$USER" == "root" ]
then
	REMOTE_HOME_DIR=/root
else
	REMOTE_HOME_DIR=/home/$USER
fi
cat $ID_FILE | ssh ${USER}@${DOMAIN} "cat >> $REMOTE_HOME_DIR/.ssh/authorized_keys"
