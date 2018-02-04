--[[ #################################################################################################################
	 ## Thermostat ## a dzVent script for Domoticz

	Helps to controls heaters using temperatures sensors

	FEATURES
	* Each Heaters is switched depending on its own target temperature
	* Heaters switching is not done at the same time, and repeated a few time, (to avoid RF collision)
	* Optionnal Master Selector
	* Each Thermostat need 4 domoticz device:
		- a Heater Switch device (On/Off), connected to the final Heater relay
		- a Selector Switch, with state at least Off, On, Auto, and optionaly Confort[n], NoFrost, etc..
		- a Temperature Sensor device
		- a User Variable, that hold taget temperature fo the day + OPTIONALLY (SEPARATED BY '-') the night, and the weekend 

	-------------------------------------------------------------
	Copyright : Francois Dechery 2017 	https://github.com/soif/
	-------------------------------------------------------------

################################################################################################################### --]]

local glob	=	require('soif_dz_vars')
local vars	=	require('soif_dz_vars_thermostat')
local func	=	require('soif_dz_utils')

glob.debug_on = true


-- ### Functions #################################################################################################
-----------------------------------------------------------------------------------------
function GetDayMode(time)
	local mode='day'

	-- sunday, saturday
	if (time['wday'] == 1 or time['wday'] == 7) then
		mode='we'
	end

	-- night
	if (isNightTime) then
		mode='night'
	end
	return mode
end

-----------------------------------------------------------------------------------------
function SelectArrayChild(array, prop_name, prop_value)
	for k, arr in pairs(vars[array]) do
		if arr[prop_name] == prop_value then
			return arr
		end
	end
end

-------------------------------------------------------------------------------------------
function DataHeaterStore(heater_id,on_off)
	local var ='states_heater_'..heater_id
	func.EchoDebug("Storing DATA : {var} = {on_off}")
	func.domoticz.data[var].add(on_off)
end

-------------------------------------------------------------------------------------------
function DataHeaterListLastRepeatingState(heater_id, on_off)
	local var ='states_heater_' .. heater_id
	func.EchoDebug("** Finding DATA : {var} = {on_off} ******* ")
	local out={}
	local continue =true
	func.domoticz.data[var].forEach(function(item,index)
								if continue then 										
									if item.data == on_off then 
										out[index]	=item.time.msAgo
										func.EchoDebug("** Same state {on_off} : {out[index]} ms ago");
									else 
										continue = false
									end
								end
							end)
	return out
end

-------------------------------------------------------------------------------------------
function SwitchHeaters(heaters , action)
	local count_therms = #vars.thermostats + 4
	--func.EchoDebug(heaters)
	for k,heater_id in pairs(heaters) do 
		local heater	= func.domoticz.devices(heater_id)
		local rand_min	= (k -1)	* 2				-- 0	2	4
		local rand_max	= k 		* count_therms	-- 10	20	30
		local offset	= (k -1)	* count_therms	-- 0	10	20
		math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) + heater_id*100 )
		local delay		= offset + math.random(rand_min, rand_max)

		if action == false then
			func.Echo("Will Turn Heater : ({heater.id}) '{heater.name}'	OFF after '{delay} seconds' ",true)
			--func.EchoDebug("Switch {heater.name} OFF after [k={k}] {offset} +{rand_min}/{rand_max} = {delay} sec")
			heater.switchOff().afterSec(delay)
			DataHeaterStore(heater_id, false)
		elseif action ==true then
			func.Echo("Will Turn Heater : ({heater.id}) '{heater.name}'	ON after '{delay} seconds' ",true)
			--func.EchoDebug("Switch {heater.name} ON after {k} {delay} sec")
			heater.switchOn().afterSec(delay)
			DataHeaterStore(heater_id, true)
		end
	end
end

-----------------------------------------------------------------------------------------
function GetWantedTemperature(uservar_id, sel_params)
	local day_mode		= GetDayMode(func.domoticz.time)	
	local raw_var 		= func.domoticz.variables(uservar_id) or ""
	-- func.EchoDebug("UserVar {uservar_id} = {raw_var.value}	Type={sel_params.type}")
	--func.EchoDebug(raw_var);
	local vars			= func.Explode('-', raw_var.value)

	local var_temps		={}
	var_temps['day']	=vars[1] or 999
	var_temps['night']	=vars[2] or var_temps['day']
	var_temps['we']		=vars[3] or var_temps['day']

	if 		sel_params.type =='auto'	then
		func.EchoDebug("Type: {sel_params.type}, Day: {day_mode}")
		return var_temps[day_mode]
	elseif	sel_params.type =='fixed'	then 
		func.EchoDebug("Type: {sel_params.type}")
		return sel_params.temperature
	else
		func.EchoDebug("Type: {sel_params.type},     we will cancel...")
		return nil
	end	
end

-------------------------------------------------------------------------------------------
function ProcessThermSensor(sensor_id)
	local sensor		=	func.domoticz.devices(sensor_id)
	local therm			=	SelectArrayChild('thermostats',		'sensor',	sensor_id)
	local selector		=	func.domoticz.devices(therm.selector);
	local sel_params	= 	SelectArrayChild('selectors_levels','level',	selector.level)
	local heaters		=	therm.heaters
	local first_heater	=	func.domoticz.devices(heaters[1])
	local cur_state		=	first_heater.active
	local new_state		=	cur_state
	local sensor_temperature=func.Round(sensor.temperature,2)

	func.EchoDebug("=> Process Temp.  Sensor '{sensor.name}' ({sensor_id})")
	func.EchoDebug("Current Temperature : {sensor_temperature}			Heater State: {cur_state}")
	local temp_wanted	= 	GetWantedTemperature(therm.uservar,sel_params)
	
	if temp_wanted == 999 then
		func.EchoDebug("ERROR : target Temperature is NOT set in the user variable {therm.uservar} ==> CANCEL ")
		return false
	elseif temp_wanted == nil then
		func.EchoDebug("Nothing to process ==> CANCEL ")
		return true
	else
		func.EchoDebug("Target  Temperature : {temp_wanted}")
	end

	
	-- Temperature is reached ?
	local diff 			= tonumber(temp_wanted) - sensor_temperature	
	func.EchoDebug("Differ. Temperature : {diff}	(Error correction {".. vars.deviation .."} ) ")

	-- do we need to change ?
	if (diff - vars.deviation) > 0 or (diff + vars.deviation) < 0 then
		func.EchoDebug("COLD, nedd to Switch ON")
		new_state = true
	else
		func.EchoDebug("HOT, nedd to Switch OFF")
		new_state = false
	end

	
	local state_dates 		= DataHeaterListLastRepeatingState(first_heater.id, new_state) -- ms
	local count_same_state  = #state_dates

	if count_same_state > 0 then 
		local last_changed		= state_dates[1] 				or  0	--ms
		local oldest_changed	= state_dates[count_same_state] or 0	--ms
		func.EchoDebug("History has {count_same_state} event : last = {last_changed/1000} s, 	oldest : {oldest_changed/1000} s")
		
		-- do we have to resend at the end of resend_dur
		if (oldest_changed/(60*1000) > vars.resend_dur) and (vars.resend_dur > 0) then
			func.EchoDebug("Oldest event is older than "..vars.resend_dur.." min ==> RESENDING OLDEST" )
			SwitchHeaters(heaters, new_state)
			return true
		end

		-- resending		
		if count_same_state < vars.resent_count then
			func.EchoDebug("State has been sent less than "..vars.resent_count.." times. Can we resend now?" )
			if last_changed/1000 > vars.resent_hold then
				func.EchoDebug("Last State is older than "..vars.resent_hold.." sec ==> RESENDING LAST" )
				SwitchHeaters(heaters, new_state)
			else
				func.EchoDebug("NO, we have to wait longer	==> CANCEL " )
			end	
		else
			func.EchoDebug("Resent count has been reached ==> CANCEL " )
		end
	else
		func.EchoDebug("Not Past events with the same state => Switching to {new_state}")
		SwitchHeaters(heaters, new_state)
	end
end

-------------------------------------------------------------------------------------------
function ProcessThermSelector(selector_id)
	local item			=	func.domoticz.devices(selector_id)
	local thermostat	=	SelectArrayChild('thermostats',		'selector',	selector_id)
	local sel_params	= 	SelectArrayChild('selectors_levels','level',	item.level)

	if thermostat.master then
		func.EchoDebug("=> Process MASTER Selector '{item.name}'	to '{sel_params.name}' ")

		for k,this_therm in pairs(vars.thermostats) do
			if this_therm.master == nil then
				func.domoticz.devices(this_therm.selector).switchSelector(sel_params.level)
			end
		end
	else
		func.EchoDebug("=> Process normal Selector '{item.name}'	to '{sel_params.name}' ")

		if sel_params.type 		== 'on' 	then
			SwitchHeaters(thermostat.heaters , true)
		elseif 	sel_params.type == 'off' 	then
			SwitchHeaters(thermostat.heaters , false)
		elseif 	sel_params.type == 'auto' 	then
			ProcessThermSensor(thermostat.sensor)
		elseif 	sel_params.type == 'fixed' 	then
			ProcessThermSensor(thermostat.sensor)
		end
	end
end

-------------------------------------------------------------------------------------------
function ProcessThermTimer()
	--TODO
end



-- #########################################################################################################
-- ### MAIN ################################################################################################
-- #########################################################################################################

return {
	-- is script active ---------------------
    active = true, -- optional
	-- triggers -----------------------------
	on = {
		devices 	= vars.watched_devices,
		variables	= vars.watched_variables,
    },
	-- persistent variables -----------------
	data = vars.persistent_data,
	
	-- main ---------------------------------
	execute = function(domoticz, item)
		-- Start --------------------------
		func.ScriptExecuteStart(vars.script_name)

		-- keep domoticz global
		func.domoticz = domoticz

		local type="Unknown" 
		
		-- what kind of trigger ?
		if item.isDevice then
			if item.temperature ~= nil then
				type='sensor'
			elseif item.switchType == "Selector" then
				type='selector'
			else
				-- type='UNKNOWN DEVICE'
			end
		elseif item.isTimer then
			type='timer'
		end

		func.EchoDebug("Triggered by '{item.name}' ({item.idx})		Type: {type}")
		
		if type == 'sensor' then
			ProcessThermSensor(item.id)
		elseif type == 'selector' then 	
			ProcessThermSelector(item.id)
		elseif type == 'selector' then 	
			ProcessThermTimer()
		end

		-- END --------------------------
		func.ScriptExecuteEnd()
	end
}
