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
- id		: (inf)				[REQUIRED] PIR idx from Domoticz
- name		: (str)				Name of your PIR. Defaults to vars.def.name
- title		: (str)				Title	of the notifications actions, Defaults to  vars.def.title or 'name'
- message	: (str)				Message	of the notifications actions, Defaults to vars.def.message
- icon		: (str)				icon to use for kodi or growl
- actions	: {str OR table}	Actions, Notification to do : growl | kodi | kodis | indicator_light | indicator_flash | nab_tts | nab_file | nab_preset
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
vars.def.dur				=10				-- Default Switch Duration
vars.def.day_mode			=1				-- Default Day Mode 0=always, 1=night, 2=day
vars.def.debounce			=9				-- Default Debounce Time
vars.def.icon				='pir.png'							-- Default icon for growl & Kodi
vars.def.icon_url			=glob.url_pmd .. '/inc/conf/icons/'	-- Default  icon url prefix added to icon.

vars.def.growl				={}
--vars.def.growl.icon_url		=glob.url_pmd .. '/inc/conf/icons/'		-- 'http://domo.lo.lo/inc/conf/icons/'
vars.def.growl.groups		='Logs,Notifications,Alertes'
vars.def.growl.group		=1;
--vars.def.growl.priority	='normal';

--vars.def.kodi				={}
--vars.def.kodi.icon_url		=glob.url_pmd .. '/inc/conf/icons/'		-- 'http://domo.lo.lo/inc/conf/icons/'




-- PIRs objects ##########################################################################
-- Define has many PIrs object as you want

-- Basic PIR example : ---------------------
-- i=i+1						-- increments the next 'i' index
-- vars.pirs[i]			={}		-- initialize table	
-- vars.pirs[i].id		=267	-- the triggering PIR device idx
-- vars.pirs[i].devices	=315	-- the switch idx, trigger by the PIR

--[[ 
This will results in PIR 237 triggereing switch 315, using default properties set in vars.def.xxx.
Note that 'vars.pirs[i].actions' defaults to 'switch' when undefined..
--]]






-- #######################################################################################
-- Remove the following PIRs Definitions and replace it by your own configuration ########
-- #######################################################################################


--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=267
vars.pirs[i].name		='Salon'
vars.pirs[i].masters	={449} -- 
vars.pirs[i].devices	={273} -- table salon

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=315
vars.pirs[i].name		='Hall'
vars.pirs[i].icon		="pir_hall.png"
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].devices	={88, 328}	--Simu1 Cuis, Sej.S
vars.pirs[i].dur		=2*60
vars.pirs[i].masters	={450} -- 

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=318
vars.pirs[i].name		='Bureau'
vars.pirs[i].icon		="pir_bureau.png"
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].devices	={413,415}	--, socket 4, leds
vars.pirs[i].dur		={60,120}
vars.pirs[i].masters	={451} -- 

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=421
vars.pirs[i].name		='Buanderie'
vars.pirs[i].icon	="pir_buanderie.png"
vars.pirs[i].actions	={'switch', 'growl'}
vars.pirs[i].devices	={414,415}	--, socket 5, leds burea
vars.pirs[i].dur		={30,10}
vars.pirs[i].day_mode	=0	-- always
vars.pirs[i].masters	={452} -- 
vars.pirs[i].growl		={}


--------------------------------------
--- OUTSIDE --------------------------
--------------------------------------

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=428
vars.pirs[i].name		='Entree'
vars.pirs[i].icon	="pir_entree.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_flash', 'nab_file'}
vars.pirs[i].masters	={455} -- 
vars.pirs[i].devices	={388} -- 388=Salon2, 271=Table Sej
vars.pirs[i].debounce	=30
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=3	--Alerts
vars.pirs[i].nabaztag	='pir'

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=423
vars.pirs[i].name		='Reverbere'
vars.pirs[i].icon		="pir_reverbere.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={453} -- 
vars.pirs[i].devices	={272} -- reverb
vars.pirs[i].dur		=5 * 60
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=425
vars.pirs[i].name		='Poulailler'
vars.pirs[i].icon		="pir_poulailler.png"
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].masters	={454} -- 
vars.pirs[i].devices	={388} -- Salon2, 271 Table Sej
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notifications

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=430
vars.pirs[i].name		='Portail'
vars.pirs[i].icon		="pir_portail.png"
vars.pirs[i].actions	={'switch', 'kodis','growl', 'indic_light', 'nab_file'}
vars.pirs[i].masters	={456} -- 
vars.pirs[i].devices	={272} -- reverb
vars.pirs[i].debounce	=90
vars.pirs[i].growl		={}
vars.pirs[i].growl.group=2	--Notif
vars.pirs[i].nabaztag	='pir'

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=433
vars.pirs[i].name		='Terrasse'
vars.pirs[i].icon		="pir_terrasse.png"
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].masters	={457} -- 
vars.pirs[i].devices	={388,271} -- Salon2, Table Sej
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




------------------------------------------------------------
-- uncomment for testing -----------------------------------
------------------------------------------------------------

--[[ 


i=i+1
vars.pirs[i]				={}
vars.pirs[i].id				=glob.but_test --glob.but_test
vars.pirs[i].name			='Maman Fait Dodo'
vars.pirs[i].message		="Mais Pourquoi donc?"
vars.pirs[i].actions		={'growl','kodi'}	-- 'switch', 'nab_file', 'kodi', 'kodis','indic_flash'
vars.pirs[i].devices		={271} -- Salon2, 271=Table Sej, 415=bureau
vars.pirs[i].debounce		=2
vars.pirs[i].dur			=2
vars.pirs[i].day_mode		=0
vars.pirs[i].icon			="pir_terrasse.png"
vars.pirs[i].growl			={}
vars.pirs[i].growl.title	="Grow Title"
--vars.pirs[i].growl.group=3	--Alerts
--vars.pirs[i].masters		={387} -- 387=Salon1 
--vars.pirs[i].dur			={5}
--vars.pirs[i].growl.priority="high"
--vars.pirs[i].nabaztag		='pir'
--vars.pirs[i].icon			="pir_reverbere.png"
--vars.pirs[i].growl.icon		="pir_hall.png"


--]]




-- END Variables ################################################################################
return vars
