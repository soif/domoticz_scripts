local vars = {}
local glob	=	require('soif_conf/globals')
vars.pirs	={}
local i=0

--[[ #################################################################################################################
	PIRS variables
################################################################################################################# --]]

vars.indicator_idx			=342		-- (int) 		idx of the Indicator Light to trigger
vars.indicator_dur			=10			-- (seconds)	Duration to show Indicator light
vars.indicator_count		=7			-- (int)		Flash Count to show Indicator light
vars.indicator_flash_color	='red'		-- (str)		alias color of the Indicator light when flashing
vars.indicator_light_color	='purple'	-- (str)		alias color of the Indicator light when lighting

vars.debounce_time			=10			-- (int)		Default debounce time

vars.def					={}
vars.def.name				='PIR';
vars.def.message			='Detecteur de mouvement';
vars.def.dur				=10;
--vars.def.priority			='HIGH';
--vars.def.prefix				='';
vars.url_growl_images 		= glob.url_pmd .. '/inc/conf/icons/'

vars.def.growl				={}
vars.def.growl.file			='pir'
--vars.solo_pir				=430 		-- 425=poule 430 portail 433=terrass	-- If defined, only this device is shown in debug mode


--[[ #################################################################################################################
	PIRS definitions
################################################################################################################# --]]
--[[ 
PIRs properties:
All properties are optionals, except the 'id'
- id		: (inf)				[REQUIRED] PIR idx from Domoticz
- name		: (str)				Name of your PIR. Defaults to vars.def.name
- title		: (str)				Title	of the notifications actions, Defaults to 'name' or vars.def.title
- message	: (str)				Message	of the notifications actions, Defaults to vars.def.message
- actions	: {str OR table}	Actions, Notification to do ? growl | kodi | kodis | indicator_light | indicator_flash | nab_tts | nab_file | nab_preset
- devices	: (int OR table)	Devices IDX to switch On (for action: 'switch')
- dur		: (int OR table) 	(seconds) Duration to stay On, can be an array (for each devices ). 0 = infinite time
- debounce	: (int)				Debounce time : 
- day_mode	: (int)				When to switch : (0) always | (1)  night | (2) day
- masters	: (int OR table)	Switch(es) IDX used to disable the PIR's actions
- growl	: 	; (table)			Properties for growl actions
	-title	: (str)				Override the PIR.title
	-message: (str)				Override the PIR.message
- nabaztag	: (str)				file, preset, or message for Nabaztag

--]]



--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=267
vars.pirs[i].name		='Salon'
vars.pirs[i].devices	={273} -- table salon
vars.pirs[i].masters	={449} -- 
vars.pirs[i].dur		=30
vars.pirs[i].day_mode		=1	-- 0 always, 1 night, 2 day

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=315
vars.pirs[i].name		='Hall'
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].devices	={88, 328}	--Simu1 Cuis, Sej.S
vars.pirs[i].masters	={450} -- 
vars.pirs[i].dur		=2*60
vars.pirs[i].day_mode	=1	-- 0 always, 1 night, 2 day
vars.pirs[i].debounce	=45
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_hall"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=318
vars.pirs[i].name		='Bureau'
vars.pirs[i].actions	={'switch','growl'}
vars.pirs[i].devices	={413,415}	--, socket 4, leds
vars.pirs[i].masters	={451} -- 
vars.pirs[i].dur		={60,180}
vars.pirs[i].day_mode	=1
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_bureau"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=421
vars.pirs[i].name		='Buanderie'
vars.pirs[i].actions	={'switch', 'growl'}
vars.pirs[i].devices	={414,415}	--, socket 5, buanderie
vars.pirs[i].masters	={452} -- 
vars.pirs[i].dur		=30
vars.pirs[i].day_mode		=0	-- 0 always, 1 night, 2 day
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_buanderie"


--------------------------------------
--- OUTSIDE --------------------------
--------------------------------------

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=428
vars.pirs[i].name		='Entree'
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_flash', 'nab_file'}
vars.pirs[i].devices	={388} -- Salon2, 271 Table Sej
vars.pirs[i].masters	={455} -- 
vars.pirs[i].day_mode		=1
vars.pirs[i].nabaztag	='pir'
vars.pirs[i].debounce	=30
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_entree"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=423
vars.pirs[i].name		='Reverbere'
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].devices	={272} -- reverb
vars.pirs[i].masters	={453} -- 
vars.pirs[i].dur		=5*60
vars.pirs[i].day_mode		=1	-- 0 always, 1 night, 2 day
vars.pirs[i].debounce	=20
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_reverbere"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=425
vars.pirs[i].name		='Poulailler'
vars.pirs[i].actions	={'switch', 'kodis', 'growl', 'indic_light'}
vars.pirs[i].devices	={388} -- Salon2, 271 Table Sej
vars.pirs[i].masters	={454} -- 
vars.pirs[i].day_mode		=1
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_poulailler"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=430
vars.pirs[i].name		='Portail'
vars.pirs[i].actions	={'switch', 'kodis','growl', 'indic_light', 'nab_file'}
vars.pirs[i].devices	={272} -- reverb
vars.pirs[i].masters	={456} -- 
vars.pirs[i].dur		=90
vars.pirs[i].day_mode		=1
vars.pirs[i].nabaztag	='pir'
vars.pirs[i].debounce	=20
vars.pirs[i].growl	={}
vars.pirs[i].growl.file="pir_portail"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=433
vars.pirs[i].name		='Terrasse'
vars.pirs[i].devices	={388,271} -- Salon2, Table Sej
vars.pirs[i].masters	={457} -- 
vars.pirs[i].day_mode	=1
vars.pirs[i].actions	={'switch', 'kodis','growl','indic_light'}
vars.pirs[i].growl		={}
vars.pirs[i].growl.file	="pir_terrasse"

--------------------------------------
i=i+1
vars.pirs[i]			={}
vars.pirs[i].id			=445
vars.pirs[i].name		='Boite Au Lettre'
vars.pirs[i].message	='Le Facteur vient de passer'
vars.pirs[i].nabaztag	='facteur'
vars.pirs[i].actions	={'kodis','growl','indic_flash','nab_file'}
vars.pirs[i].growl		={}
vars.pirs[i].growl.file="pir_bal"



-- END Variables ################################################################################

------------------------------------------------------------
-- uncomment for testing -----------------------------------
------------------------------------------------------------

--[[ 

--]]

i=i+1
vars.pirs[i]				={}
vars.pirs[i].id				=glob.but_test
vars.pirs[i].name			='Test  Xiaomi Button'
vars.pirs[i].message		="Je viens d'appuyer sur le bouton"
vars.pirs[i].actions		={'switch','growl'}	-- 'switch', 'nab_file', 'kodi', 'kodis','indic_flash'
vars.pirs[i].devices		={271} -- Salon2, 271=Table Sej, 415=bureau
--vars.pirs[i].masters		={387} -- 387=Salon1 
--vars.pirs[i].dur			={5}
vars.pirs[i].dur			=1
vars.pirs[i].day_mode		=0
vars.pirs[i].nabaztag		='pir'
vars.pirs[i].debounce		=2
vars.pirs[i].growl			={}
vars.pirs[i].growl.file		="test"
vars.pirs[i].growl.priority="high"



return vars
