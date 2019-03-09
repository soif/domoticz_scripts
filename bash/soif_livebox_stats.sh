#!/bin/bash
# NOTE : python is required for JSON Output
source `dirname $0`/soif_conf.conf



##########################################################################################
myLivebox=${SOIF_GLOB[livebox_host]}
myPassword=${SOIF_GLOB[livebox_pass]}

myTmpDir=/tmp

myFileOutput=$myTmpDir/livebox_stats_Output.txt
myFileCookies=$myTmpDir/livebox_stats_Cookies.txt


##########################################################################################
function getJsonVal () { 
    python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1))"
}


##### MAIN ###############################################################################
# Thanks to : https://github.com/NextDom/plugin-livebox/blob/master/core/class/livebox.class.php

# Connect and Save Cookies -------------------------------------------------------------------
curl -s -o "$myFileOutput" -X POST -c "$myFileCookies" -H 'Content-Type: application/x-sah-ws-4-call+json' -H 'Authorization: X-Sah-Login' -d "{\"service\":\"sah.Device.Information\",\"method\":\"createContext\",\"parameters\":{\"applicationName\":\"so_sdkut\",\"username\":\"admin\",\"password\":\"$myPassword\"}}" http://$myLivebox/ws > /dev/null

# Extract 'X-Context' value  -------------------------------------------------------------
myContextID=$(tail -n1 "$myFileOutput" | sed 's/{"status":0,"data":{"contextID":"//1'| sed 's/",//1' | sed 's/"groups":"http,admin//1' | sed 's/"}}//1')

# Grab Various Information ---------------------------------------------------------------
getDSLStats=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.dsl0\",\"method\":\"getDSLStats\",\"parameters\":{}}" http://$myLivebox/ws`
getMIBs=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NeMo.Intf.data\",\"method\":\"getMIBs\",\"parameters\":{}}" http://$myLivebox/ws`
#getVOIP=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"VoiceService.VoiceApplication\",\"method\":\"listTrunks\",\"parameters\":{}}" http://$myLivebox/ws`
#getTV=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC.OrangeTV\",\"method\":\"getIPTVStatus\",\"parameters\":{}}" http://$myLivebox/ws`
#getInternet=`curl -s -b "$myFileCookies" -X POST -H 'Content-Type: application/x-sah-ws-4-call+json' -H "X-Context: $myContextID" -d "{\"service\":\"NMC\",\"method\":\"getWANStatus\",\"parameters\":{}}" http://$myLivebox/ws`


# Close connection and remove tmp --------------------------------------------------------
curl -s -b "$myFileCookies" -X POST http://$myLivebox/logout
rm -f "$myFileCookies" "$myFileOutput"


# output as JSON -------------------------------------------------------------------------
echo '{"dhcp":'
echo "$getMIBs" | getJsonVal "['status']['dhcp']" 

echo ',"dsl":'
echo "$getMIBs" | getJsonVal "['status']['dsl']" 

echo ',"stats":'
echo "$getDSLStats" | getJsonVal "['status']" 

echo '}'

exit 0
