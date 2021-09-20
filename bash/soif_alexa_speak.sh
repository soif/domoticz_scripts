#!/bin/bash


SOIF_USAGE="TEXT [ALEXA_CTRL_ARGS]
Speak any text to your Alexa device.

 * TEXT            : Any words or sentence(s), between quotes, ie \"Hello World, I'm verry happy to speak on my Alexa device.\"
                     Text can include any allowed SSML tags, see:
                     https://developer.amazon.com/en-US/docs/alexa/custom-skills/speech-synthesis-markup-language-ssml-reference.html
 * ALEXA_CTRL_ARGS : Any other arguments from alexa_remote_control.sh
"

#
# Include --------------------
IS_INCLUDED=1
FIRST_ARG_REQUIRED=1
source `dirname $0`/soif_alexa.sh
# ----------------------------

#Use default voice, when set
if [ -n "${SOIF_ALEXA[DEFAULT_VOICE]}" ]; then
	COM_SPEAK="<speak><voice name='${SOIF_ALEXA[DEFAULT_VOICE]}'>${FIRST_ARG}</voice></speak>"
else
	COM_SPEAK="<speak>${FIRST_ARG}</speak>"
fi


source $ALEXA_CTRL_SCRIPT -e speak:"${COM_SPEAK}" ${ARG_DEVICE} ${ARGUMENTS}
