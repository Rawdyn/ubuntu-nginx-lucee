#!/bin/bash

# If no Lucee version specified, set default.
if [[ -z "${LUCEE_VERSION}"  ]]; then
	export LUCEE_VERSION="5.3.6.61"
fi
echo -e "\e[97m\n\n\n\n============================================================\n"
echo "               INSTALLING LUCEE $LUCEE_VERSION"
echo -e "\n============================================================\n\e[0m"

# If installing the light versio of Lucee
if [[ -n "${LUCEE_LIGHT}"  ]]; then
	echo -e "\e[37mInstalling Lucee Light\e[0m"
fi

# If a SHA256 provided, note we will verify against it
if [[ -n "${LUCEE_JAR_SHA256}"  ]]; then
	echo -e "\e[37mVerify Lucee against SHA256\e[0m"
	echo -e "\e[96m$LUCEE_JAR_SHA256\e[0m"
fi

# Default heap size if none specified
if [[ -z "${JVM_MAX_HEAP_SIZE}"  ]]; then
	export JVM_MAX_HEAP_SIZE="512m"
fi
echo -e "\e[37mJVM Max Heap Size will be set to \e[92m$JVM_MAX_HEAP_SIZE\e[0m"

#set JVM_FILE and JVM_VERSION if you want to use an oracle JVM, instead of openjdk
if [[ -n "${JVM_FILE}"  ]] ; then
	if [ -f $JVM_FILE ]; then
		echo -e "\e[37mJVM File '\e[92m$JVM_FILE\e[37m' found.\e[0m"
	else
		echo -e "\e[91mExpected JVM File '$JVM_FILE' not found.\e[0m"
		echo -e "\e[37mSKIPPING Oracle JVM Installation.\e[0m"
	fi
else
	echo -e "\e[37mJVM File not specified.\e[0m"
fi

if [[ -n "${WHITELIST_IP}"  ]]; then
	echo -e "\e[37mWill grant \e[92m$WHITELIST_IP\e[37m access to /lucee\e[0m"
fi

if [[ -z "${ADMIN_PASSWORD}"  ]]; then
	echo -e "\e[37mNo ADMIN_PASSWORD set\e[0m"
else
	echo -e "\e[37mADMIN_PASSWORD will be set to \e[92m$ADMIN_PASSWORD\e[0m"
fi

# root permission check
if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you need to run this script using sudo or as root."
  exit 1
fi

# Confirm to continue with install
echo -e "\e[92m"
while true; do
    read -p "Do you wish to install this program (y/n)? " yn
    case $yn in
        [Yy]* ) echo -e "\n\e[97mOK, let's do it!\e[0m"; break;;
        [Nn]* ) echo -e "\n\e[91mExiting\e[0m\n"; exit;;
        * ) ;;
    esac
done
echo -e "\e[0m"
echo -e "\e[93mRunning Installation of Lucee $LUCEE_VERSION \e[0m\n"
