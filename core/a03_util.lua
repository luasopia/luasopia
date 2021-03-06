--------------------------------------------------------------------------------
-- utility functions for debug
--------------------------------------------------------------------------------
-- this loads main.lua in 'luasopialib' folder
function import(libname)
    local url = string.format('luasopiaLib.%s.%s',libname, libname)
    global.u = function(str) return string.format('luasopiaLib/%s/%s',libname,str) end
    local lib = require(url)
    global.u = nil
    return lib
end

-- --[[
function runutil(utilname) -- runutil
    local url = string.format('luasopiaUtil.%s.main',utilname, utilname)
    global.u = function(str) return string.format('luasopiaUtil/%s/%s', utilname, str) end
    local util = require(url)
    global.u = nil
    return util
end
--]]

function _luasopia.copytable(t)
    local clone = {}
    for k, v in next, t do  clone[k] = v end
    return clone
end

_luasopia.puts = function(...) print(string.format(...)) end

_luasopia.showt = function(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

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
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
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

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
_luasopia.showg = function()


    ----[[ print global variables that are added by user
    local luag = { -- 39
    '_G', '_VERSION', 'assert', 'collectgarbage', 'coroutine', 'debug', 'dofile',
    'error', 'gcinfo', 'getfenv', 'getmetatable', 'io', 'ipairs', 'load', 'loadfile',
    'loadstring', 'math', 'module', 'newproxy', 'next', 'os', 'package', 'pairs',
    'pcall', 'print', 'rawequal', 'rawget', 'rawset', 'require', 'select', 'setfenv',
    'setmetatable', 'string', 'table', 'tostring', 'tonumber', 'type', 'unpack', 'xpcall',
    -- extra keys --
    '_Gideros',
    -- CoronaSDK는 아래 세 개는 전역변수로 있어야 정상동작한다.
    'system', 'Runtime', 'cloneArray',
    }
    local function notin(str)
        for _, v in ipairs(luag) do
            if v==str then return false end
        end
        return true
    end

    print('----------')
    for k,v in pairs(_G) do if notin(k) then print(k) end end
    print('----------')
    --]]
end