#!/bin/bash
source `dirname $0`/soif_conf.conf

##########################################################################################
# Huawei HG612 Modem : Get Statistics Info ###############################################
##########################################################################################
# by François Déchery, aka Soif - https://github.com/soif/                               #
##########################################################################################


URL="http://${SOIF_GLOB[h612_host]}/html/status/xdslStatus.asp"

RAW=$(wget -qO- "$URL")
CLEAN=`echo "$RAW" | head -n 1 | sed -E s/.*stDsl//g | sed -E s/\"//g  | sed -E "s/,/ /g" `

declare -a KEYS
declare -a VALUES

KEYS+=('state');	VALUES+=(` echo "$CLEAN" | awk '{print $2}' `)
KEYS+=('type');		VALUES+=(` echo "$CLEAN" | awk '{print $3}' `)

KEYS+=('up');		VALUES+=(` echo "$CLEAN" | awk '{print $4}' `000)
KEYS+=('down');		VALUES+=(` echo "$CLEAN" | awk '{print $5}' `000)

KEYS+=('max_up');		VALUES+=(` echo "$CLEAN" | awk '{print $8}' `000)
KEYS+=('max_down');		VALUES+=(` echo "$CLEAN" | awk '{print $9}' `000)

KEYS+=('att_up');		VALUES+=(` echo "$CLEAN" | awk '{print $10/10}' `)
KEYS+=('att_down');		VALUES+=(` echo "$CLEAN" | awk '{print $11/10}' `)

KEYS+=('pwr_up');		VALUES+=(` echo "$CLEAN" | awk '{print $12/10}' `)
KEYS+=('pwr_down');		VALUES+=(` echo "$CLEAN" | awk '{print $13/10}' `)

#KEYS+=('snr_up');		VALUES+=(` echo "$CLEAN" | awk '{print $14/10}' `)
#KEYS+=('snr_down');		VALUES+=(` echo "$CLEAN" | awk '{print $15/10}' `)

# output as JSON #########################################################################
JSON="{"
for K in "${!VALUES[@]}"; do 
	JSON+='"'
	JSON+=${KEYS[$K]}
	JSON+='": "'
	JSON+=${VALUES[$K]}
	JSON+='", '
done
JSON+="'end':''}"

echo "$JSON"
exit 0
