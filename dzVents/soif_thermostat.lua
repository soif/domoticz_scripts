--[[ #################################################################################################################
	 ## Thermostat ## a dzVent script for Domoticz

	Helps to controls heaters using temperatures sensors

	FEATURES
	* Each Heaters is switched depending on its own target temperature
	* Heaters switching is not done at the same time, and repeated a few time, (to avoid RF collision)
	* Optionnal Master Selector
	* Each Thermostat need 4 domoticz device:
		- a Heater Switch device (On/Off), connected to the final Heater relay
		- a Selector Switch, with states: Off, On, Auto, and optionaly Confort[n], NoFrost, etc..
		- a Temperature Sensor device
		- a User Variable, that hold target temperature for the day + OPTIONALLY (SEPARATED BY '-') the night, and the weekend 

	-------------------------------------------------------------
	Copyright : Francois Dechery 2017 	https://github.com/soif/
	-------------------------------------------------------------

################################################################################################################### --]]
local glob	=	require('soif_conf/globals')
local vars	=	require('soif_conf/thermostat')
local func	=	require('soif_utils')

vars.script_name	="Thermostat"

vars.debug_on = true


-- ### Functions #################################################################################################

-----------------------------------------------------------------------------------------
function GetDayMode(time)
	local mode='day'

	-- sunday, saturday
	if (time['wday'] == 1 or time['wday'] == 7) then
		mode='we'
	end

	-- night
	if (func.domoticz.time.isNightTime) then
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
	func.EchoDebug("* Finding DATA : {var} = {on_off} ******* ")
	local out={}
	local continue =true
	func.domoticz.data[var].forEach(
		function(item,index)
			if continue then 										
				if item.data == on_off then 
					out[index]	=item.time.msAgo
					func.EchoDebug(" * - Same state '{on_off}' : {out[index]/1000} sec ago");
				else 
					continue = false
				end
			end
		end
	)
	return out
end

-------------------------------------------------------------------------------------------
function SwitchThermostatDevices(heaters, action, airconds, mode)
	if ( mode == 'hot' ) then
		SwitchHeaters(heaters , action)
	end
	SwitchAirConds(airconds, action, mode)

end

-------------------------------------------------------------------------------------------
function SwitchAirConds(airconds, action, mode)
	if (airconds == nil) then
		return false
	end
	for k,aircond_id in pairs(airconds.ids) do 
		local aircond	= func.domoticz.devices(aircond_id)
		local delay		= GetRandomDelay(aircond_id, k)
		local level
		if action==false then
			 level=airconds.off[k]
			 func.Echo("Will Turn AirCond : ({aircond.id}) '{aircond.name}' OFF after '{delay} seconds' ",true)
		elseif action ==true then
			if mode == 'cold' then
				level=airconds.cold[k]
			else
				level=airconds.hot[k]
			end
			func.Echo("Will Turn AirCond : ({aircond.id}) '{aircond.name}' to level {level} '{aircond.levelNames[ level / 10 +1 ]}' after '{delay} seconds' ",true)
		end
		aircond.switchSelector(level).afterSec(delay)
		DataHeaterStore(aircond_id, action)
	end
end

-------------------------------------------------------------------------------------------
function SwitchHeaters(heaters , action)
	if (heaters == nil) then
		return false
	end

	local count_therms = #vars.thermostats + 4
	--func.EchoDebug(heaters)
	for k,heater_id in pairs(heaters) do 
		local heater	= func.domoticz.devices(heater_id)
		local delay		= GetRandomDelay(heater_id, k)

		if action == false then
			func.Echo("Will Turn Heater : ({heater.id}) '{heater.name}' OFF after '{delay} seconds' ",true)
			--func.EchoDebug("Switch {heater.name} OFF after [k={k}] {offset} +{rand_min}/{rand_max} = {delay} sec")
			heater.switchOff().afterSec(delay)
		elseif action ==true then
			func.Echo("Will Turn Heater : ({heater.id}) '{heater.name}' ON after '{delay} seconds' ",true)
			--func.EchoDebug("Switch {heater.name} ON after {k} {delay} sec")
			heater.switchOn().afterSec(delay)
		end
		DataHeaterStore(heater_id, action)
	end
end

-------------------------------------------------------------------------------------------
function GetRandomDelay(device_id, k)
	local count_therms = #vars.thermostats + 4
	local rand_min	= (k -1)	* 2				-- 0	2	4
	local rand_max	= k 		* count_therms	-- 10	20	30
	local offset	= (k -1)	* count_therms	-- 0	10	20
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) + device_id*100 )
	local delay		= offset + math.random(rand_min, rand_max)
	return delay
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
		func.EchoDebug("Target Type: {sel_params.type}, Day: {day_mode}")
		return var_temps[day_mode]
	elseif	sel_params.type =='fixed'	then 
		func.EchoDebug("Target Type: {sel_params.type}")
		return sel_params.temperature
	else
		func.EchoDebug("Target Type: {sel_params.type},     we will cancel...")
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
	local airconds		=	therm.airconds
	local first_heater
	local cur_state	
	if heaters ~= nil then
		first_heater	=	func.domoticz.devices(heaters[1])
		cur_state		=	first_heater.active
	else
		first_heater	=	func.domoticz.devices(airconds.ids[1])
		cur_state		=	false
		if first_heater.level ~= airconds.off[i]  then
			cur_state	=  true
		end
	end
	
	local new_state		=	cur_state
	local sensor_temperature=func.Round(sensor.temperature,2)

	func.EchoDebug("=> Process Temp.  Sensor '{sensor.name}' ({sensor_id})")
	func.EchoDebug("Current Temperature : {sensor_temperature}     Target ( {first_heater.id} ) State: {cur_state}")
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
	if sel_params.mode == nil	then	sel_params.mode='hot'	end
	local diff=0
	if ( sel_params.mode =='cold' ) then
		diff 			= sensor_temperature - tonumber(temp_wanted)	
	else
		diff 			= tonumber(temp_wanted) - sensor_temperature
	end

	func.EchoDebug("Diff. Temperature : {diff}   (Error correction {".. vars.deviation .."} ) ")

	-- do we need to change -----?

	if (diff - vars.deviation) > 0  then --or (diff + vars.deviation) < 0
		func.EchoDebug("Not enought ".. sel_params.mode .." , we need to Switch ON")
		new_state = true
	else
		func.EchoDebug("Too ".. sel_params.mode ..", we need to Switch OFF")
		new_state = false
	end

	
	local state_dates 		= DataHeaterListLastRepeatingState(first_heater.id, new_state) -- ms
	local count_same_state  = #state_dates

	if count_same_state > 0 then 
		local last_changed		= state_dates[1] 				or  0	--ms
		local oldest_changed	= state_dates[count_same_state] or 0	--ms
		func.EchoDebug("History has {count_same_state} event : last = {last_changed/1000} s, oldest = {oldest_changed/1000} s")
		

		-- repeating		
		if count_same_state < vars.resent_count then
			func.EchoDebug("State has been sent less than "..vars.resent_count.." times. Can we resend now?" )
			if last_changed/1000 > vars.resent_hold then
				func.EchoDebug("Last State is older than "..vars.resent_hold.." sec ==> REPEATING LAST" )
				SwitchThermostatDevices(heaters, new_state, airconds, sel_params.mode)
			else
				func.EchoDebug("NO, we have to wait longer	==> CANCEL " )
			end	
		else
			func.EchoDebug("Resent count has been reached ==> CANCEL " )
		end

		-- do we have to resend at the end of resend_dur
		if (last_changed/(60*1000) > vars.resend_dur) and (vars.resend_dur > 0) then
			func.EchoDebug("Latest event is older than "..vars.resend_dur.." min ==> RESENDING LAST" )
			SwitchThermostatDevices(heaters, new_state, airconds, sel_params.mode)
			return true
		end



	else
		func.EchoDebug("No Past events with the same state => Switching to {new_state}")
		SwitchThermostatDevices(heaters, new_state, airconds, sel_params.mode)
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
	active = vars.active,
	-- triggers -----------------------------
	on = {
		devices 	= vars.watched_devices,
		variables	= vars.watched_variables,
    },
	-- persistent variables -----------------
	data = vars.persistent_data,
	
	-- main ---------------------------------
	execute = function(domoticz, item)
		glob.debug_on = vars.debug_on

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

		func.EchoDebug("Triggered by '{item.name}' ({item.idx})           Type: {type}")
		
		if type == 'sensor' then
			ProcessThermSensor(item.id)
		elseif type == 'selector' then 	
			ProcessThermSelector(item.id)
		--todo
		elseif type == 'timer' then 	
			ProcessThermTimer()
		end
		--func.EchoDebug(domoticz.time)
		-- END --------------------------
		func.ScriptExecuteEnd()
		--glob.debug_on = false
	end
}
