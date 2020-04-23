local vars = {}
vars.thermostats	={}
local	i	=0

--[[ #################################################################################################################
	Thermostat script VARIABLES 
################################################################################################################# --]]

vars.active			=true				-- is the script active ?
vars.temp_absent	=10					-- temperature wanted in 'absent' mode


-- Thermostat definitions ------------------------------------------------------
-- ids of each thermost elements

-- MASTER --------
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].selector=123
vars.thermostats[i].master	=true

-- Salon
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=159
vars.thermostats[i].heaters	={75}
vars.thermostats[i].selector=115
vars.thermostats[i].uservar	=1

-- Cuisine
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=167
vars.thermostats[i].heaters	={77}
vars.thermostats[i].selector=117
vars.thermostats[i].uservar	=3

-- Bureau
i=i+1
vars.thermostats[i]					={}
vars.thermostats[i].sensor			=529
-- vars.thermostats[i].heaters			={324}	-- Rad Bureau ,124 r.Bureau_433
vars.thermostats[i].airconds		={}
vars.thermostats[i].airconds.ids	={561} -- Clim Bureau Selectors
vars.thermostats[i].airconds.off	={0} -- OFF Selector levels
vars.thermostats[i].airconds.hot	={10} -- HOT Selector levels
vars.thermostats[i].airconds.cold	={20} -- COLD Selector levels
vars.thermostats[i].selector=116
vars.thermostats[i].uservar	=2

-- Ch. Parents
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=163
vars.thermostats[i].heaters	={78}
vars.thermostats[i].selector=118
vars.thermostats[i].uservar	=4

-- Ch. Louis
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=164
vars.thermostats[i].heaters	={79}
vars.thermostats[i].selector=119
vars.thermostats[i].uservar	=5

-- Ch. Amis
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=162
vars.thermostats[i].heaters	={80}
vars.thermostats[i].selector=120
vars.thermostats[i].uservar	=6

-- SDB
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=165
vars.thermostats[i].heaters	={82}
vars.thermostats[i].selector=122
vars.thermostats[i].uservar	=8

-- Couloir
i=i+1
vars.thermostats[i]			={}
vars.thermostats[i].sensor	=158
vars.thermostats[i].heaters	={81}
vars.thermostats[i].selector=121
vars.thermostats[i].uservar	=7


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
		['type']		='auto',
		['mode']		='hot',
		['name']		='Auto C',
	},
	{
		['level']		=30,
		['type']		='auto',
		['mode']		='cold',
		['name']		='Auto F',
	},
	{
		['level']		=40,
		['type']		='fixed',
		['mode']		='hot',
		['name']		='Confort C',
		['temperature']	=22,
	},
	{
		['level']		=50,
		['type']		='fixed',
		['mode']		='cold',
		['name']		='Confort F',
		['temperature']	=22,
	},
	{
		['level']		=60,
		['type']		='fixed',
		['mode']		='hot',
		['name']		='NoFrost',
		['temperature']	=6,
	},
}


-- misc settings ---------------------------------------------------------------------------
vars.holidays_use_day		='sat'		-- day period setting to use when on hollidays
vars.deviation				=0.3		-- maximun temperature deviation allowed
vars.resent_count			=3			-- (count) how many time to resend the same command  (to fix heaters that may have NOT changed properly)
vars.resent_hold			=30			-- (sec) resend the same command  not before this duration
vars.resend_dur				=10			-- (min) always resend heater commands after this time 


return vars
