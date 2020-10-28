#!/bin/bash

# If no Lucee version specified, set default.
if [[ -z "${LUCEE_VERSION}"  ]]; then
	export LUCEE_VERSION="5.3.6.61"
fi
echo -e "\e[38;5;255m\n\n\n\n============================================================\n"
echo -e "               INSTALLING LUCEE \e[38;5;38m$LUCEE_VERSION\e[0m"
echo -e "\e[38;5;255m\n============================================================\n\e[0m"

#If installing the light versio of Lucee
if [[ -n "${LUCEE_LIGHT}"  ]]; then
	echo -e "\e[37mInstalling Lucee \e[38;5;38mLight\e[0m"
fi

#If a SHA256 provided, note we will verify against it
if [[ -n "${LUCEE_JAR_SHA256}"  ]]; then
	echo -e "\e[37mVerify Lucee against SHA256\e[0m"
	echo -e "\e[38;5;38m$LUCEE_JAR_SHA256\e[0m"
fi

#Default heap size if none specified
if [[ -z "${JVM_MAX_HEAP_SIZE}"  ]]; then
	export JVM_MAX_HEAP_SIZE="512m"
fi
echo -e "\e[37mJVM Max Heap Size will be set to \e[38;5;38m$JVM_MAX_HEAP_SIZE\e[0m"


#if EITHER JVM file or version specified
if [[ -n "${JVM_FILE}"  ]] || [[ -n "${JVM_VERSION}"  ]] ; then
	#if JVM_FILE requested
	f_msg="Requested custom JVM File...\n\e[38;5;38m   $JVM_FILE\e[37m\n   The custom JVM file was"
	if [[ -n "${JVM_FILE}"  ]]; then
		#if JFM_FILE exists
		if [ -f $JVM_FILE ]; then
			f_msg+="\e[92m found\e[0m."
		else
			f_msg+="\e[38;5;197m not found\e[0m."
		fi
		echo -e "$f_msg"
	fi
	#if JVM_VERSION specified	
	if [[ -n "${JVM_VERSION}"  ]]; then	
		echo -e "   \e[37mJVM Version '\e[38;5;38m$JVM_VERSION\e[37m'\e[38;5;185m CHECK\e[37m it corresponds with file.\e[0m"
	else
		echo -e "   \e[38;5;197mALERT! \e[37mExpected JVM Version not set.\e[0m"
	fi	
	if [[ -n "${JVM_FILE}"  ]] && [[ -n "${JVM_VERSION}"  ]] && [ -f $JVM_FILE ]; then
		echo -e "   \e[38;5;118mOK\e[37m to use custom JVM file and version specified.\e[0m"
	else
		echo -e "   \e[38;5;197mALERT!\e[37m Could not resolve custom JVM file and version.\e[0m"
		echo -e "   \e[38;5;197mALERT!\e[37m Default OpenJDK will be used if you proceed.\e[0m"
	fi	
else
	#As neither JVM_FILE nor JVM_VERSION were specified...
	echo -e "\e[37mNo JVM options specified so skipping custom JVM Installation.\e[0m"
fi


if [[ -n "${WHITELIST_IP}"  ]]; then
	echo -e "\e[37mWill grant \e[38;5;38m$WHITELIST_IP\e[37m access to /lucee\e[0m"
fi

if [[ -z "${ADMIN_PASSWORD}"  ]]; then
	echo -e "\e[37mNo ADMIN_PASSWORD set\e[0m"
else
	echo -e "\e[37mCFAdmin password will be set to \e[38;5;38m$ADMIN_PASSWORD\e[0m"
fi

#root permission check
if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you need to run this script using sudo or as root."
  exit 1
fi

#Confirm to continue with install
echo -e "\e[92m"
while true; do
    read -p "Do you wish to proceed with this installation (y/n)? " yn
    case $yn in
        [Yy]* ) echo -e "\n\e[38;5;118mOK, let's do it!\e[0m"; break;;
        [Nn]* ) echo -e "\n\e[38;5;197mExiting without installing.\e[0m\n"; exit;;
        * ) ;;
    esac
done
echo -e "\e[0m"
echo -e "\e[38;5;118mRunning Installation of Lucee $LUCEE_VERSION \e[0m\n"
