#!/bin/bash
source `dirname $0`/soif_livebox.inc

##########################################################################################
# Livebox : Reboot #######################################################################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################

connectLivebox 	# connect and grab myFileCookies and myContextID -------

# reboot ---------------------------------------------------------------
# curl -s -o /dev/null -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC\",\"method\":\"reboot\",\"parameters\":{}}" http://$myLivebox/ws
STATUS=$(curl -s  -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC\",\"method\":\"reboot\",\"parameters\":{}}" http://$myLivebox/ws 2>&1 )

# todo check return status. Should be : {"status":true} ----------------
#echo "$STATUS"

# quit -----------------------------------------------------------------
closeConnection ## disconnect
exit 0
