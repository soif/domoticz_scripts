#!/bin/bash
source `dirname $0`/soif_conf.conf

##########################################################################################
# Asterisk : restarts Asterisk (needed after renewing the public IP) ######################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################

HOST=${SOIF_GLOB[pbx_host]}
USER=${SOIF_GLOB[pbx_user]}


# wait if arg[1] is set ------------------------------------------------------------------
DELAY=$1
if [[ $DELAY =~ ^[0-9]+$ ]] && [ $DELAY -gt 0 ] ; then
	sleep $DELAY
fi

# restart remote asterisk ----------------------------------------------------------------
ssh ${USER}@${HOST} "/etc/init.d/asterisk restart ; exit 0; " 
exit 0
