#!/bin/bash

# require conf
source `dirname $0`/soif_conf.conf

# export conf vars to env vars
for i in "${!SOIF_ALEXA[@]}"
do
	export "$i=${SOIF_ALEXA[$i]}"
done

#######
ALEXA_CTRL_SCRIPT=`dirname $0`/alexa-remote-control/alexa_remote_control.sh

soif_help() { 
	echo "Usage: $0 $SOIF_USAGE"
	echo " * -h | --help     : show this help"
	echo

	if [ -n "$USAGE_EXIT" ];then
		exit 0
	fi
}

if [ -n "$IS_INCLUDED" ]; then
	#echo "included"
	
	#ALL_ARGUMENTS="$@"
	# keep first arg
	FIRST_ARG="$1"
	
	if [ -n "$FIRST_ARG_REQUIRED" ] && [ -z "$FIRST_ARG" ]; then
		echo "An argument is required!"
		echo
		soif_help
		exit 1;
	fi
	
	case "${FIRST_ARG}" in
        "-h" | "--help")
			soif_help
			echo "-- alexa_remote_control.sh USAGE ---------------------------------";
			;;
		*)
			shift
			;;
    esac

	# remove it from args
	ARGUMENTS="$@"

	#Use default device, if set
	if [ -n "${SOIF_ALEXA[DEFAULT_DEVICE]}" ]; then
		ARG_DEVICE="-d ${SOIF_ALEXA[DEFAULT_DEVICE]}"
	else
		ARG_DEVICE=""
		#shift
	fi

else
	source $ALEXA_CTRL_SCRIPT
fi
