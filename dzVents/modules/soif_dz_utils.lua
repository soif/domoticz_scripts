local glob	=	require('soif_dz_vars')
local fn = {}
-- Start FUNCTIONS #############################################################################
fn.script_name = 'UntitledScript'

-------------------------------------------------------------------------
function fn.ScriptExecuteStart(script_name)
	fn.script_name = script_name

	local print_debug = glob.print_debug or false

	fn.EchoDebug("\n")
	fn.EchoDebug("#############################################################################################")
	
	if not print_debug then 
		print(fn.script_name.. "Processing....") 
	end
end

-------------------------------------------------------------------------
function fn.ScriptExecuteEnd(script_name)
	fn.EchoDebug("#############################################################################################\n")
end

-------------------------------------------------------------------------
function fn.MySplit(input,sep)
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
function fn.EchoDebug(mess,parse_variables)
	fn._Print(mess, parse_variables, true)
end

-------------------------------------------------------------------------
function fn.Echo(mess,parse_variables)
	fn._Print(mess, parse_variables, false)
end


-------------------------------------------------------------------------
function fn._Print(mess, parse_variables,is_debug)
	if (glob.print_debug and is_debug) or (is_debug == false) then
		local prefix =	fn.script_name
		
		if is_debug then
			prefix	= "### " .. prefix .. " ### "
		else
			prefix	= prefix .. ": "			
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
				mess=fn.F(mess)
			end
			print(prefix .. mess .."")
			--print("### TYPE="..type(mess))
		end
	end
	
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
    local output_str = "### ARRAY {\n"

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


-- Private #############################################################################

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
function MySplit(input,sep)
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


-------------------------------------------------------------------------
function DebugVars()
	DebugPrint('otherdevices : ##########################################################')
	for i, v in pairs(otherdevices) do 
		DebugPrint(i.."	= ".. v) 
	end
	DebugPrint('otherdevices_svalues : ##################################################')
	for i, v in pairs(otherdevices_svalues) do
		DebugPrint(i.."	: ".. v) 
	end
	DebugPrint('##################################################################')
end
--]]

-------------------------------------------------------------------------
-- g_random_seed = os.clock()
-- math.randomseed(g_random_seed)

-- Start FUNCTIONS #############################################################################

return fn
