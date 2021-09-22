local glob	= require('soif_conf/globals')
local vars	= {}
vars.switches={}
local i		= 0

--[[ #################################################################################################################
   Variables
################################################################################################################# --]]

vars.active				=true
vars.script_name		="Alexa"		-- Name of the Script
vars.debug_on			=false
vars.play_script		="/root/scripts/bash/soif_alexa_sound.sh" -- Absolute path to soif_alexa_sound.sh script
vars.say_script		="/root/scripts/bash/soif_alexa_speak.sh" -- Absolute path to soif_alexa_speak.sh script

--[[ #####################################################################################
###### Switches Definitions ##############################################################
##################################################################################### --]]

-- switches,  indexed by Domoticz idx, then state => a table of {mode, alexa_*.sh argurments}
-- ie :
-- vars.switches[556]['on']		={'play','sound1'}                     --> when switch 556 state is 'on', play sound 'sound1'
-- vars.switches[556]['off']		={'say',' "Hello World" '}             --> when switch 556 state is 'off', say the sentence "Hello World"
-- vars.switches[557]['off']		={'say',' "Hello World" -d EchoDot1'}  --> when switch 557 state is 'off', say the sentence "Hello World" to device EchoDot1
-- (Beware that in 'say' mode, the sentence must be enclosed by double quotes (") ! )


i=556 --- WC
vars.switches[i]			   ={}
vars.switches[i]['on']		={'play','wc1'}
vars.switches[i]['off']		={'play','wc2'}


i=557 --- WC fan
vars.switches[i]			={}
vars.switches[i]['on']	={'play','wc3'}
--vars.switches[i]['off']	={'say',' "On respire enfin?" '}




-- END Variables ################################################################################
return vars
