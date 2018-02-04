local vars = {}
-- START Variables #############################################################################

vars.but_absent		= 67
vars.print_debug	= false

--[[

g_current_date 			= os.date('*t')
g_but_absent			="Absent"		-- name of the global "Absent Mode" button

g_url_pmd				="http://domo.lo.lo"		-- url of PhpMyDomo
g_path_scripts			="/root/scripts/"			-- path to scripts
g_path_scripts_php		=g_path_scripts .. "php/"	-- path to PHP scripts


g_sensors_temp_int = {
	154,	-- s.Bureau
  	156,	-- s.Garage
  	158,	-- s.Couloir
  	159,	-- s.Salon
  	162,	-- s.Ch. Amis
  	163,	-- s.Ch. Parents
  	164,	-- s.Ch. Louis
  	165,	-- s.SDB
  	167		-- s.Cuisine
}

g_sensors_temp_int = {
  	160,	-- s.Ext. Sud
  	166		-- s.Ext. Nord
}
--]]
-------------------------------------------------------------------------
-- g_random_seed = os.clock()
-- math.randomseed(g_random_seed)

-- END Variables #############################################################################
return vars