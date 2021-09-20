--[[ #####################################################################################
	 ## Alexa ## a dzVent script for Domoticz

	Play sounds to Alexa devices from Switches States

	-------------------------------------------------------------
	Copyright : Francois Dechery 2021 	https://github.com/soif/
	-------------------------------------------------------------

##################################################################################### --]]

local glob	=	require('soif_conf/globals')
local vars	=	require('soif_conf/alexa')
local func	=	require('soif_utils')


-- #######################################################################################
-- ### MAIN ##############################################################################
-- #######################################################################################

-- set triggers from pirs IDs ---------------------------
vars.triggers={}
for k,v in pairs(vars.switches) do
  table.insert(vars.triggers, k)
end

return {
	-- is script active ---------------------
	active = vars.active, -- optional
	on = {
		devices 	= vars.triggers,
	},
	execute = function(domoticz, item)
		-- process this button
		local switch=vars.switches[item.idx]

		-- Start --------------------------
		glob.debug_on = vars.debug_on
		func.domoticz = domoticz		--	Make Domoticz global
		vars.script_title="State from : '".. item.name.."' ("..item.idx..') ' .. '======== ' .. func.domoticz.time.rawTime
		func.ScriptExecuteStart(vars.script_name,vars.script_title)

		-- Process switch ----
		state = string.lower(item.state)
		if switch[state] ~= nil then
			command=vars.sound_script ..' '.. switch[state]
			domoticz.utils.osExecute( command )
			func.Echo("Playing Sound: ({state}) ".. switch[state])
		else
			func.EchoDebug("Nothing to play ({state})")
		end

		-- END --------------------------
		func.ScriptExecuteEnd()
	end
}
