local vars = {}

--[[ #################################################################################################################
	Thermostat script VARIABLES 
################################################################################################################# --]]

vars.script_name	="Thermostat"		-- Name of the Script
vars.temp_absent	=10					-- temperature wanted in 'absent' mode

-- rooms where day mode is forced for specified hours periods -----------------
vars.day_extra_hours = {
	['Salon']={
		{6,9},		-- 'Salon' if in 'day' mode from 6h to 9h
		{17,2},		-- 'Salon' if in 'day' mode from 17h to 2h
	},
	['SDB']={
		{6,9},
		{17,2}
	},
	['Bureau']={
	},
}

-- Thermostat definitions ------------------------------------------------------
-- ids of each thermost elements
vars.thermostats = {
	{	-- MASTER
		['selector']=123,
		['master']	=true,
	},
	{	-- Salon
		['sensor']	=159,
		['heaters']	={75},
		['selector']=115,
		['uservar']	=1,
	},
	{	-- Cuisine
		['sensor']	=167,
		['heaters']	={77},
		['selector']=117,
		['uservar']	=3,
	},
	{	-- Bureau
		['sensor']	=154,
		['heaters']	={124},
		['selector']=116,
		['uservar']	=2,
	},
	{	-- Ch. Parents
		['sensor']	=163,
		['heaters']	={78},
		['selector']=118,
		['uservar']	=4,
	},
	{	-- Ch. Louis
		['sensor']	=164,
		['heaters']	={79},
		['selector']=119,
		['uservar']	=5,
	},
	{	-- Ch. Amis
		['sensor']	=162,
		['heaters']	={80},
		['selector']=120,
		['uservar']	=6,
	},
	{	-- SDB
		['sensor']	=165,
		['heaters']	={82},
		['selector']=122,
		['uservar']	=8,
	},
	{	-- Couloir
		['sensor']	=158,
		['heaters']	={81},
		['selector']=121,
		['uservar']	=7,
	},
}

-- Selectors Level -------------------------------------------------------------------------
-- definition of levels for all selectors
vars.selectors_levels={
	{
		['level']		=0,
		['type']		='off',
	},
	{
		['level']		=10,
		['type']		='on',
	},
	{
		['level']		=20,
		['type']		='auto',
		['name']		='Auto',
	},
	{
		['level']		=30,
		['type']		='fixed',
		['name']		='Confort',
		['temperature']	=22,
	},
	{
		['level']		=40,
		['type']		='fixed',
		['name']		='NoFrost',
		['temperature']	=6,
	},
}


-- misc settings ---------------------------------------------------------------------------
vars.deviation				=0.3		-- maximun temperature deviation allowed
vars.resent_count			=3			-- (count) how many time to resend the same command  (to fix heaters that may have NOT changed properly)
vars.resent_hold			=5			-- (sec) resend the same command  not before this duration
vars.resend_dur				=900		-- (min) always resend heater commands after this time 





-- DO NOT CHANGE BELOW THIS LINE #####################################################################################

-- Build needed arrays -------------------------
vars.watched_uservars	={}
vars.watched_devices	={}
vars.persistent_data	={}

for k,arr in pairs(vars.thermostats) do
	table.insert(vars.watched_devices,	arr.selector)
	if arr.sensor ~= nil then	--skip MASTER
		table.insert(vars.watched_devices,	arr.sensor)
 		table.insert(vars.watched_uservars,	arr.uservar)
		for k,heater_id in pairs(arr.heaters) do
			vars.persistent_data["states_heater_"..heater_id]= { initial='off', history = true, maxItems = 10, maxHours = 48 }
		end
	end
end

-- Add Missing levels names --------------------
for k,arr in pairs(vars.selectors_levels) do
	if arr.name == nil then
		vars.selectors_levels[k].name=arr.type
	end
end


-- END Variables #####################################################################################################

return vars
