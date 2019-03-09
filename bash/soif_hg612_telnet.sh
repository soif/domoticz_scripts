#!/bin/bash
source `dirname $0`/soif_conf.conf

##########################################################################################
# Send Telnet Command
##########################################################################################
# examples :
#xdslcmd start --up --snr 35
#xdslcmd start --up --snr 90
#xdslcmd start --up
#xdslcmd connection --down
#xdslcmd connection --up
##########################################################################################

HOST=${SOIF_GLOB[h612_host]}
USER=${SOIF_GLOB[h612_user]}
PASS=${SOIF_GLOB[h612_pass]}

COMMAND=${COMMAND:-$1}

echo "Sending command '$COMMAND' to $HOST"
exit 0

if  true ; then
(
	sleep 0.7
	echo "$USER"
	sleep 0.1
	echo "$PASS"
	sleep 0.1
	echo sh
	sleep 0.1
	echo "$COMMAND"
	sleep 0.1
	exit
	sleep 0.1
	exit
) | telnet "$HOST" 

#) | telnet "$HOST" > "$HGFILE" 2>&1
#) | telnet "$HOST" 2>&1 | tee "$HGFILE"
	echo
	exit 0
fi
