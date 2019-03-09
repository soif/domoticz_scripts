#!/bin/bash
source `dirname $0`/soif_conf.conf

##########################################################################################
# Pfsense : reloads PPOE connection (to renew the public IP) #############################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################

HOST=${SOIF_GLOB[pfsense_host]}
USER=${SOIF_GLOB[pfsense_user]}
IF=${SOIF_GLOB[pfsense_interface]}

#IF=opt1
IF=wan

# ----------------------------------------------------------------------------------------
# https://forum.netgate.com/topic/86883/help-on-disconnect-and-reconnect-a-pppoe-connection-by-command-line/5
# ssh net@gate.lo.lo " /usr/local/sbin/pfSctl -c 'interface reload wan'; /usr/bin/logger -t ppp 'PPPoE reload executed on WAN'; exit 0 " 

ACT="interface reload $IF"
LOG="External Dzvent Script soif_pfsense is restarting PPPoE on the $IF Interface......."
ssh ${USER}@${HOST} "/usr/local/sbin/pfSctl -c '$ACT';	/usr/bin/logger -t soif '$LOG'; exit 0; " 
exit 0
