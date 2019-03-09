#!/bin/bash
source `dirname $0`/soif_livebox.inc 
# NOTE : python is required for JSON Output
##########################################################################################
# Livebox : Get Statistics Info ##########################################################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################

connectLivebox 	# connect and grab myFileCookies and myContextID -------

# Grab Various Information --------------------------------------------
getDSLStats=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.dsl0\",\"method\":\"getDSLStats\",\"parameters\":{}}" http://$myLivebox/ws`
getMIBs=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.data\",\"method\":\"getMIBs\",\"parameters\":{}}" http://$myLivebox/ws`
#getVOIP=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"VoiceService.VoiceApplication\",\"method\":\"listTrunks\",\"parameters\":{}}" http://$myLivebox/ws`
#getTV=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC.OrangeTV\",\"method\":\"getIPTVStatus\",\"parameters\":{}}" http://$myLivebox/ws`
#getInternet=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC\",\"method\":\"getWANStatus\",\"parameters\":{}}" http://$myLivebox/ws`

# output as JSON -------------------------------------------------------
echo '{"dhcp":'
echo "$getMIBs" | getJsonVal "['status']['dhcp']" 

echo ',"dsl":'
echo "$getMIBs" | getJsonVal "['status']['dsl']" 

echo ',"stats":'
echo "$getDSLStats" | getJsonVal "['status']" 

echo '}'

# quit -----------------------------------------------------------------
closeConnection ## disconnect
exit 0
