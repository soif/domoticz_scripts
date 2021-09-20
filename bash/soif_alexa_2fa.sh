#!/bin/bash

SOIF_USAGE="
Returns an authentification code build from your MFA_SECRET

"

#
# Include --------------------
IS_INCLUDED=1
USAGE_EXIT=1
source `dirname $0`/soif_alexa.sh
# ----------------------------

oathtool -b --totp "${SOIF_ALEXA[MFA_SECRET]}"

