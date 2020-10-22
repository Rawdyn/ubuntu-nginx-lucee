#!/bin/bash

function separator {
	echo -e "\e[97m\n============================================================\n\e[37m"
}

#Check Environment Settings.
#Includes confirm to proceed.
#Must be run as a sourcing script (. ./) so the 'exit' releases the entire process.
. ./pre-install-check.sh
separator

#Make sure scripts are runnable.
chown -R root scripts/*.sh
chmod u+x scripts/*.sh

#Update ubuntu software.
./scripts/100-ubuntu-update.sh
separator

#Download lucee
./scripts/200-lucee.sh
separator

#Install tomcat
./scripts/300-tomcat.sh
separator

#Install jvm
./scripts/400-jvm.sh
separator

#Install nginx
./scripts/500-nginx.sh
separator

#Configure lucee
./scripts/600-config.sh
separator

echo -e "\n\e[92mSetup Complete\e[0m\n\n"
separator
