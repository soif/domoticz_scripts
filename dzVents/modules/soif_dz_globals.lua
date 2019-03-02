local vars = {}

--[[ #################################################################################################################
	GLOBAL VARIABLES 
	Shared with
	 	- all scripts
		- the utils function module

################################################################################################################# --]]

vars.but_absent		= 67		--  Idx of the Switch device that define when you are at home or not
vars.but_hollidays	= 0			--  Idx of the Switch device that define when you are on holidays
vars.but_get_netstat= 384		--  Idx of the Switch device that manually grab INTERNET connections Stats
vars.but_test		= 337		--  Idx of a TESTING switch

vars.debug_on		= false		-- Debug mode ON : Show verbose logs
vars.debug_time		= true		-- Show Execution Time (in debug mode)

vars.url_pmd		="http://domo.lo.lo"
vars.urls_kodi		={'kodi1.lo.lo','kodi2.lo.lo'}


--- Colors -------------------------------------------------------------------------------
vars.colors = {
	['white']	= {255,255,255},
	['red']		= {255,0,1},
	['blue']	= {0,0,255},
	['green']	= {0,255,0},
	['purple']	= {255,0,70},
	['yellow']	= {255,255,0},
	['cyan']	= {0,255,255},
}

-- periods -------------------------------------------------------------------------------
vars.periods = {
	[1]	={
			['name']	='Home Awaken',
			['days']	={
					['mon']	={	{6,9},	{17,24}, {0,1}	},
					['tue']	={	{6,9},	{17,24}, {0,1}	},
					['wed']	={	{6,9},	{17,24}, {0,1}	},
					['thu']	={	{6,9},	{17,24}, {0,1}	},
					['fri']	={	{6,9},	{17,24}, {0,3}	},
					['sat']	={	{8, 		24}, {0,3}	},
					['sun']	={	{9, 		24}, {0,1}	},
		}
	},
	[2]	={
			['name']	='Away',
			['days']	={
					['mon']	={	{9,17}	},
					['tue']	={	{9,17}	},
					['wed']	={	{9,17}	},
					['thu']	={	{9,17}	},
					['fri']	={	{9,17}	},
					['sat']	={			},
					['sun']	={			},
		}
	},
	[3]	={
			['name']='Home Asleep',
			['days']={
					['mon']	={	{1,9}	},
					['tue']	={	{1,9}	},
					['wed']	={	{1,9}	},
					['thu']	={	{1,9}	},
					['fri']	={	{3,9}	},
					['sat']	={	{3,9}	},
					['sun']	={	{1,9}	},
		}
	},
}



-- #### END ######################################################################################################################

return vars
