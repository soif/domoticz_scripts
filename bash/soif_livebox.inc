#!/bin/bash
source `dirname $0`/soif_conf.conf
# NOTE : python is required for JSON Output
##########################################################################################
# Livebox Globals and Functions ##########################################################
##########################################################################################
# Copyright (C) 2018 by François Déchery, aka Soif - https://github.com/soif/            #
##########################################################################################

myLivebox=${SOIF_GLOB[livebox_host]}
myPassword=${SOIF_GLOB[livebox_pass]}
myTmpDir=/tmp

uid=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16  | awk -vdate="$(date)" '{print date$1}' | md5sum | awk '{print $1}'`

myFileOutput=$myTmpDir/soif_livebox_out_$uid.txt
myFileCookies=$myTmpDir/soif_livebox_coo_$uid.txt
myContextID=''



# Functions ##############################################################################

# Connect to livebox  --------------------------------------------------------------------
# - needs	: myFileCookies, myFileOutput, myLivebox, myPassword
# - returns	: myContextID
#
connectLivebox(){
	# Thanks to : https://github.com/NextDom/plugin-livebox/blob/master/core/class/livebox.class.php

	# Connect and Save Cookies -------------------------------------------------------------------
	curl -s -o "$myFileOutput" -X POST -c "$myFileCookies" -H 'Content-Type: application/x-sah-ws-4-call+json' -H 'Authorization: X-Sah-Login' -d "{\"service\":\"sah.Device.Information\",\"method\":\"createContext\",\"parameters\":{\"applicationName\":\"so_sdkut\",\"username\":\"admin\",\"password\":\"$myPassword\"}}" http://$myLivebox/ws > /dev/null

	# Extract 'X-Context' value  -------------------------------------------------------------
	myContextID=$(tail -n1 "$myFileOutput" | sed 's/{"status":0,"data":{"contextID":"//1'| sed 's/",//1' | sed 's/"groups":"http,admin//1' | sed 's/"}}//1')

}


# Extract JSON childs --------------------------------------------------------------------
getJsonVal () { 
    python -c "import json,sys;sys.stdout.write(json.dumps(json.load(sys.stdin)$1))"
}

# Close connection and remove tmp --------------------------------------------------------
closeConnection(){
	curl -s -b "$myFileCookies" -X POST http://$myLivebox/logout
	rm -f "$myFileCookies" "$myFileOutput"
}
