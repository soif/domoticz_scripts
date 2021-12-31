local glob	=require('soif_conf/globals')
local vars	={}
--vars.pirs	={}
--local	i	=0

--[[ #####################################################################################
	PIRS variables
##################################################################################### --]]

vars.active				=true
vars.script_name		="Absent"		-- Name of the Script
--vars.debug_on 			= true

--vars.debug_force_run	= true	-- run even if it is not the night
--vars.debug_button		= glob.but_test	-- Button to triggers (avoiding to wait each minute)

vars.night1_per_hour =9			-- Total 'On' per hour in the evening
vars.night1_durations={12,30}	-- Durations from x to y minutes in the evening  
vars.night2_per_hour =4			-- Total 'On' per hour after midnight (1.3)
vars.night2_durations={2,5}		-- Durations from x to y minutes after midnight


-- Lights devices  to use to simulate presence
vars.lights			={
	413, --- hallogene bureau
	567, --- L.Plafond
	578, --- SDB Bas
	271, --- Sej.Table
	585, --- E.Sejour
	387  --- Piano
}


-- END Variables ################################################################################
return vars
