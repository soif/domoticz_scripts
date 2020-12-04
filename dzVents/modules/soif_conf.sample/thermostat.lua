local vars 			={}
vars.thermostats	={}
local i				=0

--[[ #################################################################################################################
	Thermostat VARIABLES 
################################################################################################################# --]]
vars.active			=true				-- is the script active ?
vars.script_name	="Thermostat"		-- Name of the Script
--vars.debug_on 		= true

vars.temp_absent			=10			-- temperature wanted in 'absent' mode
vars.holidays_use_day		='sat'		-- day period setting to use when on hollidays
vars.deviation				=0.2		-- maximun temperature deviation allowed
vars.resent_count			=3			-- (count) how many time to resend the same command  (to fix heaters that may have NOT changed properly)
vars.resent_hold			=30			-- (sec) resend the same command  not before this duration
vars.resend_dur				=15			-- (min) always resend heater commands after this time 



--[[ #################################################################################################################
	Thermostat definitions 
################################################################################################################# --]]
--[[ 
Thermostats properties: 
- selector	: (int)				[REQUIRED] Selector ID used to define the thermostat modes (off, hot, clod, auto hot, auto cold, Confort hot, Coonfort Cold, NoFrost)
- sensor	: (int)				[REQUIRED] Temperature sensor ID
- heaters	: (table)			Table of Heaters IDs
- airconds	: {}				Empty table (needed when using the following Air Condionners)
- airconds.ids	: (table)		Air Conditionners Ids (an Aiconditionner his a Selector (ie triggerings IR commands), with up to 3 level (off, Hot, Cold)
- airconds.off	: (int)				The "off" Level of the Air Conditionners Selectors
- airconds.hot	: (int)				The "hot" Level of the Air Conditionners Selectors
- airconds.cold	: (int)				The "cold" Level of the Air Conditionners Selectors
- uservar	: (int)				ID of the Domoticz UserVar stroring the wanted temperatures(format=TempDay-TempNight-TempWe, ie :21-18-23 Only TempDay is required, others are optionnals)
- hours			: {}			Empty table (needed when using the following hours). If hours are not defined, Domoticz internal Night and Day modes are used
- hours.day		: (table)			list of hours treated as 'day' (other will be treated as 'night')
- hours.we		: (table)			list of hours treated as 'day', ONLY during the WeekEnd (if not set, hours.day will be used)
--]]


-- Thermostats objects ##########################################################################
--[[ 

-- MASTER --------
-- define a global Master selector, which governs all others selectors 
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].selector=123
vars.thermostats[i].master	=true


-- Sejour ------------------------
i=i+1
vars.thermostats[i]					={}
vars.thermostats[i].selector		=115	-- Main Selector ID
vars.thermostats[i].sensor			=685	-- Sensor ID
--vars.thermostats[i].heaters		={75}	-- Heaters Ids
vars.thermostats[i].airconds		={}		-- AirCoditionners
vars.thermostats[i].airconds.ids	={488}	-- Clim Salon (Slave Selectors Ids)
vars.thermostats[i].airconds.off	={0}	-- OFF Selector levels
vars.thermostats[i].airconds.hot	={10}	-- HOT Selector levels
vars.thermostats[i].airconds.cold	={20}	-- COLD Selector levels
vars.thermostats[i].uservar			=1		-- UserVariable ID
vars.thermostats[i].hours			={}
vars.thermostats[i].hours.day		={0,1,5,6,7,8,9,17,18,19,20,21,22,23,24}
vars.thermostats[i].hours.we		={0,1,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}


-- Bureau (Gite) -----------------------
i=i+1	
vars.thermostats[i]					={}
vars.thermostats[i].selector		=116	-- Main Selector ID
vars.thermostats[i].sensor			=682	-- Sensor ID
vars.thermostats[i].heaters			={324}	-- Rad Bureau ,124 r.Bureau_433
vars.thermostats[i].airconds		={}		-- AirCoditionners
vars.thermostats[i].airconds.ids	={561}	-- Clim Bureau (Slave Selectors Ids)
vars.thermostats[i].airconds.off	={0}	-- OFF Selector levels
vars.thermostats[i].airconds.hot	={10}	-- HOT Selector levels
vars.thermostats[i].airconds.cold	={20}	-- COLD Selector levels
vars.thermostats[i].uservar			=2		-- UserVariable ID
vars.thermostats[i].hours			={}
vars.thermostats[i].hours.day		={7,8,9,10,11,12,13,14,15,16,17,18,19,20}
vars.thermostats[i].hours.we		={  9,10,11,12,13,14,15,16,17,18,19}


-- Piscine (Pompe) ------------------------
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].selector=117
vars.thermostats[i].sensor	=635
vars.thermostats[i].heaters	={386}
vars.thermostats[i].uservar	=3
--vars.thermostats[i].hours			={}
--vars.thermostats[i].hours.day		={0,1,2,3,4,5,6,7,8,9,10,11,12}


-- Ch. Louis ------------------------------
i=i+1
vars.thermostats[i]					={}
vars.thermostats[i].sensor			=671
vars.thermostats[i].heaters			={637}
vars.thermostats[i].selector		=119
vars.thermostats[i].uservar			=5
vars.thermostats[i].hours			={}
vars.thermostats[i].hours.day		={7,8,9,10,11,12,13,14,15}
vars.thermostats[i].hours.we		={9,10,11,12,13,14,15,16,17,18,19,20,21}



-- Ch. Parents -------------------------
i=i+1
vars.thermostats[i]					={}
vars.thermostats[i].sensor			=663
vars.thermostats[i].heaters			={638}
vars.thermostats[i].selector		=118
vars.thermostats[i].uservar			=4
vars.thermostats[i].hours			={}
vars.thermostats[i].hours.day		={8,9,10,11,12,13,14,15,16,17,18,19,20}
vars.thermostats[i].hours.we		={9,10,11,12,13,14,15,16,17,18,19,20,21}


------------------------------------------------------------------------------------------

--
-- Ch. Amis
--i=i+1
--vars.thermostats[i]			={}
--vars.thermostats[i].sensor	=162
--vars.thermostats[i].heaters	={80}
--vars.thermostats[i].selector=120
--vars.thermostats[i].uservar	=6
--
-- SDB
--i=i+1
--vars.thermostats[i]			={}
--vars.thermostats[i].sensor	=165
--vars.thermostats[i].heaters	={82}
--vars.thermostats[i].selector=122
--vars.thermostats[i].uservar	=8
--
-- Couloir
--i=i+1
--vars.thermostats[i]			={}
--vars.thermostats[i].sensor	=158
--vars.thermostats[i].heaters	={81}
--vars.thermostats[i].selector=121
--vars.thermostats[i].uservar	=7


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
		['mode']		='hot',
	},
	{
		['level']		=20,
		['type']		='on',
		['mode']		='cold',
	},
	{
		['level']		=30,
		['type']		='auto',
		['mode']		='hot',
		['name']		='Auto C',
	},
	{
		['level']		=40,
		['type']		='auto',
		['mode']		='cold',
		['name']		='Auto F',
	},
	{
		['level']		=50,
		['type']		='fixed',
		['mode']		='hot',
		['name']		='Confort C',
		['temperature']	=23,
	},
	{
		['level']		=60,
		['type']		='fixed',
		['mode']		='cold',
		['name']		='Confort F',
		['temperature']	=22,
	},
	{
		['level']		=70,
		['type']		='fixed',
		['mode']		='hot',
		['name']		='NoFrost',
		['temperature']	=6,
	},
}


return vars