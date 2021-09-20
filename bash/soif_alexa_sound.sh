#!/bin/bash

SOIF_USAGE="PRESET|SOUND|URL [ALEXA_CTRL_ARGS]
Play a sound to your Alexa device.

 * PRESET          : A shorcut to an Amazon Sound File, defined in configuration as SOIF_ALEXA[sound_PRESET]=SOUND
 * SOUND           : An (Amazon hosted) Sound file without the \"soundbank://soundlibrary/\" prefix, as listed at 
                     https://developer.amazon.com/en-US/docs/alexa/custom-skills/ask-soundlibrary.html
 * URL             : A valid MP3 file hosted at an Internet-accessible HTTPS endpoint, See: 
                     https://developer.amazon.com/en-US/docs/alexa/custom-skills/speech-synthesis-markup-language-ssml-reference.html#audio
 * ALEXA_CTRL_ARGS : Any other arguments from alexa_remote_control.sh
"

#
# Include --------------------
IS_INCLUDED=1
FIRST_ARG_REQUIRED=1
source `dirname $0`/soif_alexa.sh
# ----------------------------

#Use default sounds ("sound_*"), when set
if [ -n "${SOIF_ALEXA[sound_$FIRST_ARG]}" ]; then
	FIRST_ARG=${SOIF_ALEXA[sound_$FIRST_ARG]}
fi

# Do no prefix URLs
if [[ $FIRST_ARG == https* ]]; then
	SPEAK_SRC_URL=$FIRST_ARG
else
	SPEAK_SRC_URL="soundbank://soundlibrary/${FIRST_ARG}"
fi

source $ALEXA_CTRL_SCRIPT -e speak:"<speak><audio src='${SPEAK_SRC_URL}' /></speak>" ${ARG_DEVICE} ${ARGUMENTS}
