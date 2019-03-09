--[[ #################################################################################################################
	 ## PIRs ## a dzVent script for Domoticz

	Control device from PIRs

	-------------------------------------------------------------
	Copyright : Francois Dechery 2017 	https://github.com/soif/
	-------------------------------------------------------------

################################################################################################################### --]]

local glob	=	require('soif_conf/globals')
local vars	=	require('soif_conf/pirs')
local func	=	require('soif_utils')

---- Vars --------------------------------------------------------------------------------

vars.script_name		="PIR Event"		-- Name of the Script
vars.active				=true

--vars.debug_on			=true
--vars.solo_pir			=glob.but_test

-- ### Functions #################################################################################################

local this_pir	={}

-----------------------------------------------------------------------------------------
function InitPir(conf, item)

	-- defaults
	this_pir			= {}
	this_pir.id			= conf.id			or 0
	this_pir.name		= conf.name			or vars.def.name		or item.name or ''
	this_pir.title		= conf.title		or vars.def.title		or this_pir.name or ''
	this_pir.message	= conf.message		or vars.def.message		or ''
	this_pir.icon		= conf.icon			or vars.def.icon		or ''
	this_pir.url_icon	= conf.url_icon		or vars.def.url_icon		or ''
	this_pir.day_mode	= conf.day_mode		or vars.def.day_mode	or 0
	this_pir.debounce	= conf.debounce		or vars.def.debounce 	or 0

	this_pir.actions	= TableDefault(conf.actions ,	vars.def.action or 'switch')
	this_pir.devices	= TableDefault(conf.devices)
	this_pir.dur		= TableDefault(conf.dur,		vars.def.dur, 		this_pir.devices)
	this_pir.masters	= TableDefault(conf.masters,	vars.def.master		)	

	this_pir.growl		= TableDefault(conf.growl,	vars.def.growl)	
	this_pir.kodi		= TableDefault(conf.kodi,	vars.def.kodi)	

	-- set all cases when the item is active
	this_pir.is_active		=false
	this_pir.is_active_name	='[OFF]'
	if ( (item.active or (item.switchType=='Selector' and item.lastLevel >9) ) ) then		
		this_pir.is_active		=true
		this_pir.is_active_name='[ON] '
	end

	--func.EchoDebugLine()
	--func.EchoDebug(this_pir)

	this_pir.obj		= item
end

-----------------------------------------------------------------------------------------
function TableDefault(var, default, to_fill)
	local l_end=0
	if type(to_fill)=='number'	then
		l_end =to_fill
	elseif type(to_fill)=='table' then
		l_end =func.TableCount(to_fill)
	end
	
	--Table with no to_fill
	if (l_end == 0 and (type(var) =='table' or type(default) =='table')) then
		var = var or {}
		if (type(default) =='table' and not func.TableIsEmpty(default)) then
			for k,v in pairs(default) do
				if(not func.TableHasKey(var,k)) then
					var[k]=v
				end
			end
		end
	else		

		local  value=var or default
		-- string, with to_fill 
		if l_end > 0 then
			local filled={}
			local l_start=1

			if type(var) == 'table' then
				filled= var
				l_start = func.TableCount(filled) +1 
				l_end = l_start + l_end - func.TableCount(filled) -1
			end

			for i=l_start, l_end do
				filled[i] = value
			end
		
			if type(default)=='table' then
				var = default
			else
				var = filled		
			end
		-- string, with NO to_fill 
		else
			if type(var)=='table' then
				--var=func.TableCopy(var)	
			else
				var={ value }	
			end
		end
	end
	return var
end


-----------------------------------------------------------------------------------------
function HandleActions (act)
	func.EchoDebug("Action: '" .. act .. "' ...")
	local title		= this_pir.title
	local mess 		= this_pir.message
	local nabaztag 	= this_pir.nabaztag

	
	-- Switches -------------------------
	if act =='switch' then
		SwitchDevices()

	-- kodi -------------------------
	elseif act =='kodi' then
		NotifyKodi(glob.urls_kodi[1])

	-- all kodis --------------------------
	elseif act =='kodis' then
		if(not func.TableIsEmpty(glob.urls_kodi)) then
	        for k,host in pairs(glob.urls_kodi) do
				NotifyKodi(host)
			end
		else
			func.EchoDebug("+ Error! glob.urls_kodi is not set")
		end

	-- growl --------------------------
	elseif act =='growl' then
		NotifyGrowl(this_pir)

	-- nab_tts --------------------------
	elseif act =='nab_tts' then
		nabaztag=nabaztag or mess or title
		NotifyNabaztag('tts', nabaztag)

	-- nab_file --------------------------
	elseif act =='nab_file' then
		nabaztag=nabaztag or ''
		NotifyNabaztag('file', nabaztag)

	-- nab_preset --------------------------
	elseif act =='nab_preset' then
		nabaztag=nabaztag or ''
		NotifyNabaztag('preset', nabaztag)

	-- indic_flash --------------------------
	elseif act =='indic_flash' then
		NotifyIndicatorLamp(vars.indicator_idx, vars.indicator_flash_color)

	-- indic_light --------------------------
	elseif (act =='indic_light') then
		NotifyIndicatorLamp(vars.indicator_idx, vars.indicator_light_color, vars.indicator_dur)

	-- color --------------------------
	elseif ( glob.colors[act] ~= nil) then
		NotifyIndicatorLamp(vars.indicator_idx, act, vars.indicator_dur)
	end

end



-----------------------------------------------------------------------------------------
function SwitchDevices()
	if (this_pir.devices) then
		for k,device_id in pairs(this_pir.devices) do

			local device=func.domoticz.devices(device_id)

			if( this_pir.day_mode==0 or (this_pir.day_mode==1 and func.domoticz.time.isNightTime ) or (this_pir.day_mode==2 and func.domoticz.time.isDayTime ) ) then
				--func.EchoDebug("Switch: ".. func.domoticz.devices(device_id).name)

				dur=this_pir.dur[k]
							
				if(dur > 0) then
					SwitchDeviceFor(device , dur)
				else
					device.switchOn()
				end
			else
				func.EchoDebug("~ NO Switching, because Day_Mode = ".. this_pir.day_mode)
			end
		end
	else
		func.EchoDebug("* NO Devices defined!")
	end
end


-----------------------------------------------------------------------------------------
function SwitchDeviceFor (device,	dur)
	--func.Echo("Switching: '".. device.name .. "'	for " .. dur .. " Sec")
	--device.switchOn().checkFirst().forSec(dur)
	--device.switchOn().forSec(dur)

	if (device.active) then
		--func.Echo("Switching OFF '".. device.name .. "'	AFTER " .. dur .. " sec")
		func.EchoDebug("+ Switch '".. device.name .. "'	: CANCEL, already On!")
		--device.switchOff().afterSec(dur)
	else
		func.Echo("+ Switch '".. device.name .. "'	: set ON FOR   " .. dur .. " sec")
		device.switchOn().forSec(dur)
	end

end


-----------------------------------------------------------------------------------------
function NotifyKodi(host)
	local p		= this_pir.kodi 			or {}

	p.title		= this_pir.kodi.title		or this_pir.title	or ''
	p.message	= this_pir.kodi.message		or this_pir.message	or ''
	p.image		= this_pir.kodi.icon		or this_pir.icon 	or this_pir.growl.icon or ''
	p.time		= this_pir.kodi.time		or 10
	
	p.image		=PrefixIcon( p.icon_url,  p.image )
	p.icon_url	=nil	-- (just in case) be sure to NOT pass it to Url, else PMD will ALSO append it to icon
	
	p.title			=func.UrlEncode(p.title)
	p.message		=func.UrlEncode(p.message)
	p.image			=func.UrlEncode(p.image)

	local url 	= glob.url_pmd .. '/action?type=xbmc&server='.. host ..  ArrayToUrlQuery(p)

	func.EchoDebug("+ Url: " .. url .. " " )
	--func.EchoDebug(p)
	TriggerUrl(url)
end


-----------------------------------------------------------------------------------------
function PrefixIcon( prefix_url, icon)
	if (not func.isEmpty(icon) and  not func.isEmpty(prefix_url)) then
		icon = prefix_url .. icon 
	end
	return icon
end


-----------------------------------------------------------------------------------------
function NotifyGrowl()
	local p		= this_pir.growl			or {}
	p.title		= this_pir.growl.title		or this_pir.title	or ''
	p.message	= this_pir.growl.message	or this_pir.message	or ''
	p.icon		= PrefixIcon( p.icon_url,  p.icon )
	p.icon_url	=nil	-- be sure to NOT pass it to Url, else PMD will ALSO append it to icon
	
	p.title		=func.UrlEncode(p.title)
	p.message	=func.UrlEncode(p.message)
	p.icon		=func.UrlEncode(p.icon)

	local url = glob.url_pmd .. '/action?type=growl'.. ArrayToUrlQuery(p)

	func.EchoDebug("+ Url: " .. url .. " " )
	--func.EchoDebug(p)
	TriggerUrl(url)
end

-----------------------------------------------------------------------------------------
function ArrayToUrlQuery(params)
	local query_fields={} 
	for key,value in pairs(params) do
		if (value ~=nil ) then
			query_fields[key] = value
		end
	end
	return _aueryToString(query_fields)
end

-----------------------------------------------------------------------------------------
function _aueryToString(fields)
	local query =''
	if(not func.TableIsEmpty(fields)) then
		for key,value in pairs(fields) do
		query = query .. '&' .. key ..'=' .. value
		end
	end
	return query
end

-----------------------------------------------------------------------------------------
function NotifyNabaztag(mode, mess)
	mode	= mode		or 'tts'
	mess	= mess		or ''

	mess=func.UrlEncode(mess)
	local url ='';
	if mode=='tts' then
		url = glob.url_pmd .. '/action?type=nabaztag&mode=tts&text='.. mess ;
	elseif mode=='file' then
		url = glob.url_pmd .. '/action?type=nabaztag&preset=say_file&file='.. mess ;
	elseif mode=='preset' then
		url = glob.url_pmd .. '/action?type=nabaztag&preset='.. mess ;
	end
	TriggerUrl(url)
	func.EchoDebug("NotifyNabaztag :  " .. url .. " " )
end

-----------------------------------------------------------------------------------------
function NotifyIndicatorLamp(idx, color, sec)
	if (color == nil)   then rgb = glob.colors['blue']  else rgb = glob.colors[color] end
	sec	=	sec or 0
	local num = vars.indicator_count

	--func.domoticz.devices(idx).cancelQueuedCommands()
	--func.domoticz.devices(idx).dimTo(0)
	--func.domoticz.devices(idx).switchOff()	--.cancelQueuedCommands()

	if func.domoticz.devices(idx).active	 then
		func.EchoDebug(func.domoticz.devices(idx).name .. " Already ON  ")
		func.domoticz.devices(idx).cancelQueuedCommands()
		--func.domoticz.devices(idx).dimTo(0)
		--func.domoticz.devices(idx).switchOff()	--.cancelQueuedCommands()
	end
	func.domoticz.devices(idx).setRGB(rgb[1], rgb[2], rgb[3]).afterSec(0.1)

	if sec == 0 then
		func.EchoDebug(func.domoticz.devices(idx).name .. " - Flash Color: [" .. rgb[1] ..", ".. rgb[2] ..", ".. rgb[3] .."] for (num) :  " .. num .. " ")
		func.domoticz.devices(idx).dimTo(100).forSec(0.1).repeatAfterSec(0.1, num) 
		func.domoticz.devices(idx).switchOff().afterSec(0.2 * num + 1)
	else
		func.EchoDebug(func.domoticz.devices(idx).name .. " - Set Color: [" .. rgb[1] ..", ".. rgb[2] ..", ".. rgb[3] .."] for (sec) :  " .. sec .. " ")
		func.domoticz.devices(idx).dimTo(100).forSec(sec)	
		func.domoticz.devices(idx).switchOff().afterSec(sec)
	end

end


----------------------------------------------------
function TriggerUrl(url)
	--os.execute("curl  '" .. url .."'")
	os.execute("curl  '" .. url .."' > /dev/null 2>&1 &")
end

----------------------------------------------------
function GetPirFromId(id)
	for k,v in pairs(vars.pirs) do
		if v.id == id then
			return v
		end
	end	
end



--[[
----------------------------------------------------
function NotifyIndicatorLamp1(idx, rgb, brightness)
	rgb 		= rgb			or '0000FF'
	brightness	= brightness	or 100
	local url = func.domoticz.settings['Domoticz url']..'/json.htm?type=command&param=setcolbrightnessvalue&idx='..idx..'&hex='..rgb..'&brightness='..brightness..'&iswhite=false'
	TriggerUrl(url)
	--domoticz.openURL(url)
end
--]]

	




-- #########################################################################################################
-- ### MAIN ################################################################################################
-- #########################################################################################################

-- set triggers from pirs IDs ---------------------------
vars.triggers={}
for k,v in pairs(vars.pirs) do
  	table.insert(vars.triggers, v.id)
end
-- func.Echo(vars.triggers)

return {
	active = vars.active,
	on = {
		devices 	= vars.triggers ,	-- {glob.but_test}
   },
   data = {
		upd_dates	={ initial = {} },
   },
	execute = function(domoticz_obj, item)
		glob.debug_on = vars.debug_on

		func.domoticz = domoticz_obj		--	Make Domoticz global

		local pir= GetPirFromId(item.idx)
		InitPir(pir, item)	-- current pir defaults 

		-- Solo Debug  --------------------------		
		if (vars.solo_pir ~= nil and  vars.solo_pir > 0) then
			if ( vars.solo_pir == item.idx ) then
				this_pir.debounce =7200
			else
				glob.debug_on = false
			end
		end
		
				
		-- Start Log --------------------------
		vars.script_title=this_pir.is_active_name.." from: '".. this_pir.name.."' ("..this_pir.id..') ' .. '======== ' .. func.domoticz.time.rawTime
		func.ScriptExecuteStart(vars.script_name, vars.script_title)
		func.EchoDebugLine()

		--handle debounce time	----------------------------------	
		local do_process=true
		if (this_pir.debounce > 0) then
			
			-- init persistent data
			if func.domoticz.data.upd_dates[item.idx] == nil then
				func.domoticz.data.upd_dates[item.idx] =func.domoticz.time.dDate - this_pir.debounce
			end
			
			-- is debounce time over?
			func.EchoDebug("Debouncing... Last trig: ".. ( func.domoticz.time.dDate - func.domoticz.data.upd_dates[item.idx]).. " sec ago - Debounce: ".. this_pir.debounce ..' sec')
			if ( ( func.domoticz.time.dDate - func.domoticz.data.upd_dates[item.idx]) >= this_pir.debounce ) then
				func.EchoDebug("+ Expired! Processing...")
				do_process = true
			else
				func.Echo("+ Debounce: Skip! ")
				do_process = false
			end

		else
			func.EchoDebug("+ Ignoring Debounce : " .. this_pir.debounce)
		end	

	
		-- handle Masters Switches	---------------------------------------------
		if(this_pir.masters) then
			--func.EchoDebug(this_pir.masters)			
			local on=0
			for k,master_sw_id in pairs(this_pir.masters) do
				local dev=func.domoticz.devices(master_sw_id)
				if dev.active then 
					on = on + 1
				else
					func.EchoDebug("Master switch '" .. dev.name .."' (" .. master_sw_id .. ") is OFF")
				end
			end
			
			-- all master sw must be on
			if ( on < func.TableCount(this_pir.masters)) then
				func.Echo("NO action, a master switch is OFF")
				this_pir.actions= this_pir.actions_off or {}
				-- do_process = false
			end
		end
		

		-- main process	---------------------------------------------
		if ( this_pir.is_active ) then

			if do_process then		
				-- Actions ---------------
				if(this_pir.actions) then
					-- update db					
					func.domoticz.data.upd_dates[item.idx] =func.domoticz.time.dDate

					for k,action in pairs(this_pir.actions) do
						HandleActions(action)
					end
				end
				--reset PIR state
				item.switchOff().silent().afterSec(1)		
			end
		else
			local last = func.domoticz.time.dDate - func.domoticz.data.upd_dates[item.idx]
			func.EchoDebug("OFF event ignored !!! ( Last event trigered: ".. last  ..' sec ago)' )
		end
		
		-- END --------------------------
		func.ScriptExecuteEnd()
	end
}
