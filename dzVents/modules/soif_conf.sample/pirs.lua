local glob	=require('soif_conf/globals')
local vars	={}
vars.pirs	={}
local	i	=0

--[[ #####################################################################################
	PIRS variables
##################################################################################### --]]

vars.active				=true
vars.script_name		="PIR Event"		-- Name of the Script
--vars.debug_on			=true
--vars.solo_pir			=glob.but_test
--vars.solo_pir			=556	 --restroom


vars.indicator_idx			=342		-- (int) 		idx of the Indicator Light to trigger
vars.indicator_dur			=10			-- (seconds)	Duration to show Indicator light
vars.indicator_count		=7			-- (int)		Flash Count to show Indicator light
vars.indicator_flash_color	='red'		-- (str)		alias color of the Indicator light when flashing
vars.indicator_light_color	='purple'	-- (str)		alias color of the Indicator light when lighting




--[[ #####################################################################################
###### PIRS Definitions ##################################################################
##################################################################################### --]]
--[[ 
PIRs properties: 
All properties are optionals, except the 'id'
- id		: (int)				[REQUIRED] PIR idx from Domoticz
- name		: (str)				Name of your PIR. Defaults to vars.def.name
- title		: (str)				Title	of the notifications actions, Defaults to  vars.def.title or 'name'
- message	: (str)				Message	of the notifications actions, Defaults to vars.def.message
- trigger	: (bool)			Triggering State. Default to true (ON)
- min_on	: (int)				Minimum time ON (when triggering from OFF)
- reset		: (bool)			Reset the PIR to the opposite state when completed
- icon		: (str)				icon to use for kodi or growl
- actions	: {str OR table}	Actions, Notification to do : switch | growl | kodi | kodis | indicator_light | indicator_flash | nab_tts | nab_file | nab_preset
- devices	: (int OR table)	Devices IDX to switch On (for action: 'switch')
- dur		: (int OR table) 	(seconds) Duration to stay On, can be an array (for each devices ). 0 = infinite time
- day_mode	: (int)				When to switch : (0) always | (1)  night | (2) day
- debounce	: (int)				Debounce time : 
- masters	: (int OR table)	Switch(es) IDX used to enable/disable the PIR's actions

- growl		; (table)			Properties table for the growl action :
	-title	: (str)				Override the PIR.title
	-message: (str)				Override the PIR.message

- kodi		; (table)			Properties table for kodi and kodis actions :
	-title	: (str)				Override the PIR.title
	-message: (str)				Override the PIR.message

- nabaztag	: (str)				(TO REFACTOR) file, preset, or message for Nabaztag

--]]

-- Defaults ###############################################################################
-- theses default values will be stored in your PIRs objects properties, when not set.

vars.def					={}				-- Initialize Optionnals Defaults
--vars.def.title			='PIR'			-- Default title 
vars.def.message			='Detection'	-- Default message 
--vars.def.trigger			=true			-- Default Trigger state
vars.def.dur				=100			-- Default Switch Duration
vars.def.day_mode			=1				-- Default Day Mode 0=always, 1=night, 2=day
vars.def.debounce			=9				-- Default Debounce Time
--vars.def.reset			=true			-- Default Reset to opposite state when completed
vars.def.icon				='pir.png'							-- Default icon for growl & Kodi
vars.def.icon_url			=glob.url_pmd .. '/inc/conf/icons/'	-- Default url prefix added to icon.

vars.def.growl				={}
--vars.def.growl.icon_url		=glob.url_pmd .. '/inc/conf/icons/'		-- Default url prefix added to icon, ie: 'http://domo.lo.lo/inc/conf/icons/'
vars.def.growl.groups		='Logs,Notifications,Alertes'				-- Default Growl Groups list
vars.def.growl.group		=1;											-- Default Growl Group
--vars.def.growl.priority	='normal';									-- Default Growl Priority

--vars.def.kodi				={}
--vars.def.kodi.icon_url		=glob.url_pmd .. '/inc/conf/icons/'		-- 'Default url prefix added to icon, ie: 'http://domo.lo.lo/inc/conf/icons/'




-- PIRs objects ##########################################################################
--[[ 

Define has many PIRs object as you want.


	Each PIRS object represent a PIR (or Switch) indexed by the Id of the triggering Domoticz device (pir.id).
	When this Switch id is pressed (ON state), and if all masters buttons (when set in pir.masters) are ON, the devices (pir.devices) are switched ON, for a duration of pir.dur seconds, and optional actions (pir.actions) are performed (growl, kodi or nabaztag nofications).
	
	- pir.day_mode allows to restrict to day or night only usage (ie choose night, for PIR activating outdoor lights)
	- pir.debounce allows to ignore the same event if at leat debounce time has not elapsed.
	- pir.reset , when set to true, resets the triggering device to the opposite state when the action has completed. This is useful to get nice Domoticz graphs for PIR sensors that only send ON commands, but never go back to the OFF state (so shown as lines instead or pulses).

	Using pir.trigger=FALSE invert the logic required to activate the PIR operations, ie the triggering device has to send a OFF command (ON are ignored).
	This is usefull if you have PIR sensors that send OFF commands, or if you'd like to trigger an action whenever someone switch a button OFF.
		Ie: for the RestRoom, you want that when someone switch OFF the light (pir.id), the fan (pir.device) will be activated for 5min (pir.dur=300).
	In this case, you can use the pir.min_on to define the minimum duration beteween the previous (ignored) ON command, and this (triggering) OFF command.
		Ie: you can only activate the fan when the person has spent at least XX seconds in the RestRoom... ;-)


A Basic PIR example :
	i=i+1							-- increments the next 'i' index
	vars.pirs[i]			={}		-- initialize table	
	vars.pirs[i].id			=267	-- the triggering PIR device idx
	vars.pirs[i].devices	=315	-- the switch idx, trigger by the PIR

	This will results in PIR 267 triggering device 315, using default properties set in vars.def.xxx.
	Note that 'vars.pirs[i].actions' defaults to 'switch' when undefined.


--]]



-- #######################################################################################
-- Remove the following PIRs Definitions and replace it by your own configuration ########
-- #######################################################################################

-- 	The following are examples that I use at Home or as Tests.

-- OK --------------------------------

vars.pirs[i]			={}
vars.pirs[i].id			=267
vars.pirs[i].name		='Salon'
vars.pirs[i].icon		="pir_salon.png"
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].masters	={449} -- use Sejour
vars.pirs[i].devices	={271}	-- Sej.Table
vars.pirs[i].dur		={30}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications


-- OK 19/08/21--------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=315
vars.pirs[i].name		='Hall'
vars.pirs[i].icon		="pir_hall.png"
vars.pirs[i].actions	={'growl','indic_light'}
vars.pirs[i].masters	={450} -- use Hall
vars.pirs[i].devices	={388}	-- Salon2
vars.pirs[i].dur		={5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK --------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=827
vars.pirs[i].name		='SDB'
vars.pirs[i].icon		="pir_sdb.png"
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].masters	={828} -- use SDB
vars.pirs[i].devices	={578}	-- SDB Bas
vars.pirs[i].dur		={300}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications


-- OK --------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=318
vars.pirs[i].name		='Gite'
vars.pirs[i].icon		="pir_gite.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={451} -- use Gite
vars.pirs[i].devices	={581}	--, G.Cuisine
vars.pirs[i].dur		={60,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications



--- PILES CHANGÉES LE 6/9/2020


--------------------------------------
--- OUTSIDE --------------------------
--------------------------------------

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=421	-- B01
vars.pirs[i].name		='PoolHouse'
vars.pirs[i].icon		="pir_piscine.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={452,555} -- use PoolHouse + Exterieur
vars.pirs[i].devices	={412,388}	-- Piscine, Salon2
vars.pirs[i].dur		={240,5}
--vars.pirs[i].debounce	=120
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21-------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=423	-- B02
vars.pirs[i].name		='Murier'
vars.pirs[i].icon		="pir_murier.png"
vars.pirs[i].actions	={'switch', 'kodis','growl', 'indic_light', 'nab_file'}
vars.pirs[i].masters	={453,555}		-- use Murier + Exterieur
vars.pirs[i].devices	={568,276,388}	-- E.Cuisine, Murier, Salon2
vars.pirs[i].dur		={180,240,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='pir'

-- OK 19/08/21-------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=428	-- B04
vars.pirs[i].name		='Entree'
vars.pirs[i].icon		="pir_entree.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_flash', 'nab_file'}
vars.pirs[i].masters	={455} 
vars.pirs[i].devices	={634,388} -- Entree, Salon2
vars.pirs[i].dur		={180,5}
vars.pirs[i].debounce	=30
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='pir'

-- OK 19/08/21-------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=430	-- B05
vars.pirs[i].name		='Allee'
vars.pirs[i].icon		="pir_allee.png"
vars.pirs[i].actions	={'switch', 'kodis','growl', 'indic_light', 'nab_file'}
vars.pirs[i].masters	={456,555} -- Use Allée + Exxterieur
vars.pirs[i].devices	={278, 388} -- allee, Salon2
vars.pirs[i].dur		={300,5}
--vars.pirs[i].debounce	=90
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='pir'

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=433	-- B06
vars.pirs[i].name		='Barbecue'
vars.pirs[i].icon		="pir_barbec.png"
vars.pirs[i].actions	={'switch', 'kodis','growl', 'indic_light', 'nab_file'}
vars.pirs[i].masters	={457,555} -- use Barbecue + Exterieur
vars.pirs[i].devices	={585,388}	-- E.Sejour, Salon2
vars.pirs[i].dur		={180,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='pir'

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=434	-- B07
vars.pirs[i].name		='Bois'
vars.pirs[i].icon		="pir_bois.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={458,555} -- use Bois + Exterieur
vars.pirs[i].devices	={274,388}	-- Bois, Salon2
vars.pirs[i].dur		={180,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications


-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=439	-- B08
vars.pirs[i].name		='Chalet'
vars.pirs[i].icon		="pir_chalet.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={459,555} 	-- use Chalet + Exterieur
vars.pirs[i].devices	={611,612,388}		-- ,Chalet Est, Chalet Ouest, Salon2
vars.pirs[i].dur		={180,180,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications


-- OK ------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=441	-- B10
vars.pirs[i].name		='Portail'
vars.pirs[i].icon		="pir_portail.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={460,555}	-- use Portail + Exterieur
vars.pirs[i].devices	={} 	-- 
vars.pirs[i].dur		={}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=443	-- B10
vars.pirs[i].name		='Garage'
vars.pirs[i].icon		="pir_garage.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={461,555}	-- use Garage + Exterieur
vars.pirs[i].devices	={606,388} 	-- Gar.Ouest + Salon2
vars.pirs[i].dur		={300,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=444	-- B11
vars.pirs[i].name		='Est'
vars.pirs[i].icon		="pir_est.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_flash'}
vars.pirs[i].masters	={462,555}	-- use Est + Exterieur
vars.pirs[i].devices	={604,611,388} 	-- Gar.Est + Chalet Est + Salon2
vars.pirs[i].dur		={120,120,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=628	-- B12
vars.pirs[i].name		='Buanderie'
vars.pirs[i].icon		="pir_buanderie.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_flash'}
vars.pirs[i].masters	={630,555}	-- use Buanderie + Exterieur
vars.pirs[i].devices	={580,276,388} 	-- Buanderie + Murier + Salon2
vars.pirs[i].dur		={120,30,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=618	-- B13
vars.pirs[i].name		='Jardinage'
vars.pirs[i].icon		="pir_jardinage.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={625,555} 	-- use Jardinage + Exterieur
vars.pirs[i].devices	={568,612,388}		-- E.cuisine , Chalet Ouest, Salon2
vars.pirs[i].dur		={120,120,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=620	-- B14
vars.pirs[i].name		='Terrasee S'
vars.pirs[i].icon		="pir_terrasse_s.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={626,555}	-- use Terrasse S + Exterieur
vars.pirs[i].devices	={606,388} 	-- Gar.Ouest + Salon2
vars.pirs[i].dur		={120,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

-- OK 19/08/21------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=624	-- B15
vars.pirs[i].name		='Neflier'
vars.pirs[i].icon		="pir_neflier.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={627,555}	-- use Neflier + Exterieur
vars.pirs[i].devices	={606,412,388} 	-- Gar.Ouest + Piscine + Salon2
vars.pirs[i].dur		={120,60,5}
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications



--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=445
vars.pirs[i].name		='Boite Au Lettre'
vars.pirs[i].message	='Le Facteur vient de passer'
vars.pirs[i].icon		="pir_bal.png"
vars.pirs[i].actions	={'kodis','growl','indic_flash','nab_file'}
vars.pirs[i].day_mode	=2	-- day only
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='facteur'


--------------------------------------
--- MISC --------------------------
--------------------------------------
i=i+1
vars.pirs[i]			={}
--vars.pirs[i].id		=glob.but_test 
vars.pirs[i].id			=556 -- wc light
vars.pirs[i].name		='WC'
vars.pirs[i].message	='Ventil WC'
--vars.pirs[i].icon		="pir_bal.png"
vars.pirs[i].actions	={'switch'}
-- vars.pirs[i].masters	={} 	-- use ....
vars.pirs[i].devices	={557}		-- wc air
vars.pirs[i].dur		={300}
vars.pirs[i].day_mode	=0	-- everytime
vars.pirs[i].trigger	=false	-- on leave
vars.pirs[i].reset		=false	-- dont reset
vars.pirs[i].min_on		=105		-- only when longer than 



------------------------------------------------------------
-- uncomment for testing -----------------------------------
------------------------------------------------------------


--[[ 

i=i+1
vars.pirs[i]				={}
vars.pirs[i].id				=glob.but_test --glob.but_test
vars.pirs[i].name			='TEST BUTTON'
vars.pirs[i].message		="TEST BUTTON pressed"
vars.pirs[i].actions		={'growl'}	-- 'switch', 'nab_file', 'kodi', 'kodis','indic_flash'
vars.pirs[i].devices		={388} -- Salon2, 271=Table Sej, 415=bureau
vars.pirs[i].debounce		=10
vars.pirs[i].dur			=20
vars.pirs[i].day_mode		=0
vars.pirs[i].trigger		=false
--vars.pirs[i].icon			="pir_terrasse.png"
vars.pirs[i].growl			={}
vars.pirs[i].growl.group=3	--Alerts

--vars.pirs[i].masters		={387} -- 387=Salon1 
--vars.pirs[i].dur			={5}
--vars.pirs[i].growl.priority="high"
--vars.pirs[i].nabaztag		='pir'
--vars.pirs[i].icon			="pir_reverbere.png"
--vars.pirs[i].growl.icon		="pir_hall.png"


--]]




-- END Variables ################################################################################
return vars
