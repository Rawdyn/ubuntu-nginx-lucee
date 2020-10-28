#!/bin/bash

red="\e[38;5;197m"
gry="\e[37m"
wht="\e[38;5;255m"
blu="\e[38;5;38m"
grn="\e[38;5;118m"
ylw="\e[38;5;185m"
rst="\e[0m"
# If no Lucee version specified, set default.
if [[ -z "${LUCEE_VERSION}"  ]]; then
	export LUCEE_VERSION="5.3.6.61"
fi
echo -e "${wht}\n\n\n\n============================================================\n"
echo -e "               INSTALLING LUCEE ${blu}$LUCEE_VERSION${rst}"
echo -e "${wht}\n============================================================\n${rst}"

#If installing the light versio of Lucee
if [[ -n "${LUCEE_LIGHT}"  ]]; then
	echo -e "${gry}Installing Lucee ${blu}Light${rst}"
fi

#If a SHA256 provided, note we will verify against it
if [[ -n "${LUCEE_JAR_SHA256}"  ]]; then
	echo -e "${gry}Verify Lucee against SHA256${rst}"
	echo -e "${blu}$LUCEE_JAR_SHA256${rst}"
fi

#Default heap size if none specified
if [[ -z "${JVM_MAX_HEAP_SIZE}"  ]]; then
	export JVM_MAX_HEAP_SIZE="512m"
fi
echo -e "${gry}JVM Max Heap Size will be set to ${blu}$JVM_MAX_HEAP_SIZE${rst}"


if [[ -n "${WHITELIST_IP}"  ]]; then
	echo -e "${gry}Will grant ${blu}$WHITELIST_IP${gry} access to /lucee${rst}"
fi

if [[ -z "${ADMIN_PASSWORD}"  ]]; then
	echo -e "${gry}No ADMIN_PASSWORD set${rst}"
else
	echo -e "${gry}CFAdmin password will be set to ${blu}$ADMIN_PASSWORD${rst}"
fi

#if EITHER JVM file or version specified
if [[ -n "${JVM_FILE}"  ]] || [[ -n "${JVM_VERSION}"  ]] ; then
	#if JVM_FILE requested
	fv_error=false
	f_msg="Requested custom JVM File...\n${blu}   $JVM_FILE${gry}\n   The custom JVM file was"
	if [[ -n "${JVM_FILE}"  ]]; then
		#if JFM_FILE exists
		if [ -f $JVM_FILE ]; then
			f_msg+="${grn} found${rst}."
		else
			f_msg+="${red} not found${rst}."
			fv_error=true
		fi
		echo -e "$f_msg"
	fi
	#if JVM_VERSION specified
	if [[ "$fv_error" == false ]]; then
		if [[ -n "${JVM_VERSION}"  ]]; then	
			echo -e "   ${gry}JVM Version '${blu}$JVM_VERSION${gry}'${ylw} CHECK${gry} it corresponds with file.${rst}"
		else
			echo -e "   ${red}ALERT! ${gry}Expected JVM Version not set.${rst}"
			fv_error=true
		fi
	fi
	if [[ "$fv_error" == false ]]; then
		echo -e "   \e[38;5;118mOK${gry} to use custom JVM file and version specified.${rst}"
	else
		echo -e "   ${red}ALERT!${gry} Could not resolve custom JVM file and version.${rst}"
		echo -e "   ${red}ALERT!${gry} Default OpenJDK will be used if you proceed.${rst}"
	fi	
else
	#As neither JVM_FILE nor JVM_VERSION were specified...
	echo -e "${gry}No JVM options specified so skipping custom JVM Installation.${rst}"
fi


#root permission check
if [ "$(whoami)" != "root" ]; then
  echo "Sorry, you need to run this script using sudo or as root."
  exit 1
fi

#Confirm to continue with install
if [[ "$fv_error" == false ]]; then
	echo -e "${grn}"
else
	echo -e "${red}"
fi
while true; do
    read -p "Do you wish to proceed with this installation (y/n)? " yn
    case $yn in
        [Yy]* ) echo -e "\n${grn}OK, let's do it!${rst}"; break;;
        [Nn]* ) echo -e "\n${red}Exiting without installing.${rst}\n"; exit;;
        * ) ;;
    esac
done
echo -e "${rst}"
echo -e "${grn}Running Installation of Lucee $LUCEE_VERSION ${rst}\n"
