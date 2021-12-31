--[[ #################################################################################################################
	 ## Absent ## a dzVent script for Domoticz

	Randdomly switch devices to simutate a presence, when you're absent

	-------------------------------------------------------------
	Copyright : Francois Dechery 2020 	https://github.com/soif/
	-------------------------------------------------------------

################################################################################################################### --]]
local glob	=	require('soif_conf/globals')
local vars	=	require('soif_conf/absent')
local func	=	require('soif_utils')




-- #########################################################################################################
-- ### MAIN ################################################################################################
-- #########################################################################################################
-- http://stackoverflow.com/questions/20154991/generating-uniform-random-numbers-in-lua
math.randomseed(os.time()*123456789017)

return {
	-- is script active ---------------------
	active = vars.active,
	-- triggers -----------------------------
	on = {
		devices 	= {vars.debug_button},
		timer 		= {'every minute'}
    },
	-- persistent variables -----------------
	--data = vars.persistent_data,
	
	-- main ---------------------------------
	execute = function(domoticz, item)
		glob.debug_on = vars.debug_on

		-- Start --------------------------
		func.ScriptExecuteStart(vars.script_name)

		-- keep domoticz global
		func.domoticz = domoticz

		-- ############################################

		-- when but_absent is on
		if func.domoticz.devices(glob.but_absent).active then
			func.EchoDebug('Absent Mode')
			local lights_count		= #vars.lights  -- table.getn(lights)
			local rand_max			= lights_count * 60 *10
			local night1_min		= math.floor(rand_max - (rand_max * vars.night1_per_hour / ( 60 * lights_count)))
			local night2_min		= math.floor(rand_max - (rand_max * vars.night2_per_hour / ( 60 * lights_count)))
			-- func.EchoDebug(string.format('%s : %s and %s', rand_max, night1_min, night2_min))
	
			--during night only
			if (func.domoticz.time.isNightTime or vars.debug_force_run) then
				func.EchoDebug('Simulating Presence: Do we need to switch someting on')
				for i, device_id in pairs(vars.lights) do 
		
					-- after midnight ------
					if(func.domoticz.time.hour < 13) then
						my_rand		= math.random(1,rand_max)
						my_min		= night2_min	
						duration	= math.random(vars.night2_durations[1],vars.night2_durations[2])	
					-- evenings -------
					else
						my_rand		= math.random(1,rand_max)
						my_min		= night1_min	
						duration	= math.random(vars.night1_durations[1],vars.night1_durations[2])	
					end	
					
					local OnOff 		= (my_rand >= my_min and "On"  or "Off") -- %2 == 0 odd or even decides
					
					--only send On commands
					local device=func.domoticz.devices(device_id)
					if ( not device.active and OnOff=="On" ) then
						device.switchOn().forMin(duration)
						func.Echo("Switching : '"..device.name.."' ("..device.id..") ON for "..duration.." minutes !")
					else
						func.EchoDebug( string.format("%s      CANCEL (%s < %s / %s ) => %s, %s min",string.sub(device.name,1,10), my_rand, my_min, rand_max, OnOff, duration))
					end		
				end
			else
				func.EchoDebug('This not the night ==> CANCEL')
			end
			
		   -- all off in the morning
--[[
		   minutesnow = g_current_date.min + g_current_date.hour * 60
			offset = 30
			if (minutesnow == timeofday['SunriseInMinutes'] + offset) then
				for i, command in pairs(lights) do 
					commandArray[command] = 'Off'
					print('---> Simul : '..command..' stopped this morning !')
				end			
		   end
		
--]]		

		else
			func.EchoDebug('But Absent is not swithced ON ==> CANCEL')
		end

		-- END --------------------------
		func.ScriptExecuteEnd()
		--glob.debug_on = false
	end
}
