local glob	=	require('soif_dz_globals')
local fn = {}
-- Start FUNCTIONS #############################################################################
fn.script_name 			= 'UntitledScript'

fn.script_time_start 	= os.clock()
fn.script_time_last		= fn.script_time_start
fn.script_time_end		= fn.script_time_end

-------------------------------------------------------------------------
function fn.ScriptExecuteStart(script_name,script_title)
	fn.script_name = script_name
	script_title = script_title or "Runing: "..script_name.." ..."
	--local debug_on = glob.debug_on or false

	fn.EchoDebug("\n")
	fn.EchoDebug("#####################################################################################")
	
	if not glob.debug_on then 
		-- fn.Echo(fn._StrPad(script_title..' ', 60,'=') ) 
	end
		fn.Echo(fn._StrPad(script_title..' ', 60,'=') ) 
end

-------------------------------------------------------------------------
function fn.ScriptExecuteEnd()
	local end_time = fn.GetExecTime(true)
	if glob.debug_time and glob.debug_on then
		fn.EchoDebug("################################################ Execution Time : {end_time} #########\n")
	else
		fn.EchoDebugLine(true)
	end
	glob.debug_on = false
end


-------------------------------------------------------------------------
function fn.GetExecTime(since_start)
	local from = fn.script_time_last
	if since_start then from = fn.script_time_start end
	fn.script_time_last =  os.clock()
	return string.format("%.3f sec", os.clock() - from)
end

-------------------------------------------------------------------------
function fn.EchoDebugLine(line_break)
	line_break = line_break or false
	local cr=''
	if (line_break) then cr="\n" end
	fn.EchoDebug("#####################################################################################" .. cr )
end


-------------------------------------------------------------------------
function fn.EchoDebug(mess, parse_variables)
	if parse_variables == nil then parse_variables = true end
	fn._Print(mess, parse_variables, true)
end

-------------------------------------------------------------------------
function fn.Echo(mess, parse_variables)
	if parse_variables == nil then parse_variables = true end
	fn._Print(mess, parse_variables, false)
end

-------------------------------------------------------------------------
function fn._Print(mess, parse_variables, is_debug)
	if parse_variables == nil then parse_variables = true end

	if (glob.debug_on and is_debug) or (is_debug == false) then
		local prefix =	fn._StrPad(fn.script_name, 13,'.')
		
		if is_debug then
			prefix	= "#####  " .. prefix .. " #### "
		else
			prefix	= "===== [" ..prefix .. "] === "			
		end

		if type(mess) == "table" then
			fn.print_r(mess)
		elseif type(mess) == "nil" then
			print(prefix .. " print NIL !!!!")			
		elseif mess == "\n" then
			print("\n")
		elseif mess == "\n\n" then
			print("\n\n")
		else
			if parse_variables then
				if type(mess) == "string" then
					mess=fn.F(mess)
				end
			end
			print(prefix .. mess .."")
			--print("### TYPE="..type(mess))
		end
	end
	
end



-------------------------------------------------------------------------
function fn.Explode(sep,input)
	--if sep == nil then
	--	sep = "%s"
	--end
	local out={} ; i=1
    for str in input.gmatch(input, "([^"..sep.."]+)") do
		out[i] = str
		i = i + 1
	end
	return out
end


-------------------------------------------------------------------------
function fn.Round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end

-----------------------------------------------------------------------------------------
function fn.TableIsEmpty (table)
	if table == nil then return true end
    for _, _ in pairs(table) do
        return false
    end
    return true
end

-----------------------------------------------------------------------------------------
function fn.TableHasKey(table,key)
    return table[key] ~= nil
end

-----------------------------------------------------------------------------------------
function fn.TableCount(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end
-----------------------------------------------------------------------------------------
function fn.UrlEncode(str)
   if str then
      str = str:gsub("\n", "\r\n")
      str = str:gsub("([^%w %-%_%.%~])", function(c)
         return ("%%%02X"):format(string.byte(c))
      end)
      str = str:gsub(" ", "+")
   end
   return str	
end

-------------------------------------------------------------------------
-- variables interpolation;ie f"{a} {b}"
-- http://hisham.hm/2016/01/04/string-interpolation-in-lua/
function fn.F(str)
   local outer_env = _ENV
   return (str:gsub("%b{}", function(block)
      local code = block:match("{(.*)}")
      local exp_env = {}
      setmetatable(exp_env, { __index = function(_, k)
         local stack_level = 5
         while debug.getinfo(stack_level, "") ~= nil do
            local i = 1
            repeat
               local name, value = debug.getlocal(stack_level, i)
               if name == k then
                  return value
               end
               i = i + 1
            until name == nil
            stack_level = stack_level + 1
         end
         return rawget(outer_env, k)
      end })
      local fn, err = load("return "..code, "expression `"..code.."`", "t", exp_env)
      if fn then
         return tostring(fn())
      else
         error(err, 0)
      end
   end))
end

-------------------------------------------------------------------------
function fn._StrPad(str,len,char)
	char =char or ' '
	str= string.sub (str, 1, len)
	local pad = len - #str
	if pad > 0 then
		str = str .. string.rep(char, pad)	
	end
	return str
end

-------------------------------------------------------------------------
-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function fn.print_r(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "#####  ARRAY {\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end


-- Private #####################################################################################




-- OLD FUNCTIONS #############################################################################
--[[

-------------------------------------------------------------------------
function fn.SetGlobalVariables(table)
	if type(table) == 'table' then
		for k,v in pairs(table) do
			glob[k]=v
		end
	end
end

-------------------------------------------------------------------------
function fn.Array_keys(arr, as_number)
	local get_key=1
	if as_number then
		get_key=2
	end
	return _array_keys_or_values(arr,get_key)
end

-------------------------------------------------------------------------
function _array_keys_or_values(arr, get_key)
	local out={}
	local n=0

	for k,v in pairs(arr) do
		n=n+1
		if get_key==0 then
			out[n]=v
		elseif get_key==1 then
			out[n]=k
		elseif get_key==2 then
			out[n]=tonumber(k)
		end
	end
	return out
end

-------------------------------------------------------------------------
--https://stackoverflow.com/questions/7274380/how-do-i-display-array-elements-in-lua
function fn.print_r1(arr, indentLevel)
    local str = ""
    local indentStr = "#"

    if(indentLevel == nil) then
        print(fn.print_r(arr, 0))
        return
    end

    for i = 0, indentLevel do
        indentStr = indentStr.."\t"
    end

    for index,value in pairs(arr) do
        if type(value) == "table" then
            str = str..indentStr..index..": \n".. fn.print_r(value, (indentLevel + 1))
        else 
            str = str..indentStr..index..": "..value.."\n"
        end
    end
    return str
end

-------------------------------------------------------------------------
function TimeDifference(s)
   year = string.sub(s, 1, 4)
   month = string.sub(s, 6, 7)
   day = string.sub(s, 9, 10)
   hour = string.sub(s, 12, 13)
   minutes = string.sub(s, 15, 16)
   seconds = string.sub(s, 18, 19)
   t1 = os.time()
   t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
   difference = os.difftime (t1, t2)
   return difference
end

-------------------------------------------------------------------------
function Sleep(n)
  os.execute("sleep " .. tonumber(n))
end

-------------------------------------------------------------------------
function TriggerUrl(url)
	DebugPrint("Fetching Url : "..url)
	os.execute('curl -m 0.5 "'..url..'"')
end

--]]

-- END  #########################################################################################

return fn
