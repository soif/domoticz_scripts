#!/bin/bash
source `dirname $0`/soif_livebox.inc

##########################################################################################
# Livebox : Renew Public IP ##############################################################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################

connectLivebox 	# connect and grab myFileCookies and myContextID -------

# renew dhcp -----------------------------------------------------------
OUT_NULL=''
#OUT_NULL=-"-o /dev/null"

STATUS_OFF=$(	curl -s "$OUT_NULL" -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.data\",\"method\":\"setFirstParameter\",\"parameters\":{\"name\":\"Enable\",\"value\":0,\"flag\":\"dhcp\",\"traverse\":\"down\"}}" http://$myLivebox/ws )
sleep 1
STATUS_ON=$(	curl -s "$OUT_NULL" -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.data\",\"method\":\"setFirstParameter\",\"parameters\":{\"name\":\"Enable\",\"value\":1,\"flag\":\"dhcp\",\"traverse\":\"down\"}}" http://$myLivebox/ws )


# quit -----------------------------------------------------------------
closeConnection ## disconnect

# Execute post script --------------------------------------------------------------------
POST=${SOIF_GLOB[livebox_post]}
if [[ -n $POST ]] ; then
	$POST &>/dev/null &
fi

exit 0
