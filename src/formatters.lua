-- module will not return anything, only register formatters with the main assert engine
local assert = require('luassert.assert')

local function fmt_string(arg)
  return string.format("(string) '%s'", arg)
end

local function fmt_number(arg)
  return string.format("(number) %s", tostring(arg))
end

local function fmt_boolean(arg)
  return string.format("(boolean) %s", tostring(arg))
end

local function fmt_nil(arg)
  return "(nil)"
end

local function fmt_table(arg)
  local tmax = 3    -- max nesting-level displayed
  local ft

  ft = function(t, l)
    local result = ""
    for k, v in pairs(t) do
      if type(v) == "table" then
        if l < tmax then
          result = result .. string.format(string.rep(" ",l * 2) .. "[%s] = {\n%s }\n", tostring(k), tostring(ft(v, l + 1):sub(1,-2)))
        else
          result = result .. string.format(string.rep(" ",l * 2) .. "[%s] = { ... more }\n", tostring(k))
        end
      else
        if type(v) == "string" then v = "'"..v.."'" end
        result = result .. string.format(string.rep(" ",l * 2) .. "[%s] = %s\n", tostring(k), tostring(v))
      end
    end
    return result
  end

  local result = "(table): {\n" .. ft(arg, 1):sub(1,-2) .. " }\n"
  result = result:gsub("{\n }\n", "{ }\n") -- cleanup empty tables
  result = result:sub(1,-2)                -- remove trailing newline
  return result
end

local function fmt_function(arg)
  local debug_info = debug.getinfo(arg)
  return string.format("%s @ line %s in %s", tostring(arg), tostring(debug_info.linedefined), tostring(debug_info.source))
end

assert:addformatter(fmt_string, "string")
assert:addformatter(fmt_number, "number")
assert:addformatter(fmt_boolean, "boolean")
assert:addformatter(fmt_nil, "nil")
assert:addformatter(fmt_table, "table")
assert:addformatter(fmt_function, "function")
