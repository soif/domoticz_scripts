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
vars.sound_script		="/root/scripts/bash/soif_alexa_sound.sh" -- Absolute path to soif_alexa_sound.sh script

--[[ #####################################################################################
###### Switches Definitions ##############################################################
##################################################################################### --]]

-- switches,  indexed by Domoticz idx
--	- on	: (on state) alexa_sound.sh argurments
--	- off	: (off state) alexa_sound.sh argurments


i=556 --- WC
vars.switches[i]			   ={}
vars.switches[i]['on']		='"wc1"'
vars.switches[i]['off']		='"wc2"'


i=557 --- WC fan
vars.switches[i]			={}
vars.switches[i]['on']	='"wc3"'



-- END Variables ################################################################################
return vars
