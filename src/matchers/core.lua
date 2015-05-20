-- module will return the list of matchers, and registers matchers with the main assert engine

-- matchers take 2 parameters;
-- 1) value
-- 2) arguments list. The list has a member 'n' with the argument count to check for trailing nils

local assert = require('luassert.assert')
local astate = require ('luassert.state')
local util = require ('luassert.util')
local s = require('say')

local function format(val)
  return astate.format_argument(val) or tostring(val)
end

local function unique(value, arguments)
  local list = value
  local deep = arguments[1]
  for k,v in pairs(list) do
    for k2, v2 in pairs(list) do
      if k ~= k2 then
        if deep and util.deepcompare(v, v2, true) then
          return false
        else
          if v == v2 then
            return false
          end
        end
      end
    end
  end
  return true
end

local function near(value, arguments)
  local argcnt = arguments.n
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "near", 2, tostring(argcnt) }))
  local expected = tonumber(arguments[1])
  local tolerance = tonumber(arguments[2])
  local actual = tonumber(value)
  local numbertype = "number or object convertible to a number"
  assert(expected, s("assertion.internal.badargtype", { "near", numbertype, format(arguments[1]) }))
  assert(tolerance, s("assertion.internal.badargtype", { "near", numbertype, format(arguments[2]) }))
  if not actual then return false end
  return (actual >= expected - tolerance and actual <= expected + tolerance)
end

local function matches(value, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "matches", 1, tostring(argcnt) }))
  local pattern = arguments[1]
  local actualtype = type(value)
  local actual = nil
  if actualtype == "string" or actualtype == "number" or
     actualtype == "table" and (getmetatable(value) or {}).__tostring then
    actual = tostring(value)
  end
  local init = arguments[2]
  local plain = arguments[3]
  local stringtype = "string or object convertible to a string"
  assert(type(pattern) == "string", s("assertion.internal.badargtype", { "matches", "string", type(arguments[1]) }))
  assert(init == nil or tonumber(init), s("assertion.internal.badargtype", { "matches", "number", type(arguments[2]) }))
  if not actual then return false end
  return (actual:find(pattern, init, plain) ~= nil)
end

local function equals(value, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "equals", 1, tostring(argcnt) }))
  return value == arguments[1]
end

local function same(value, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "same", 1, tostring(argcnt) }))
  if type(value) == 'table' and type(arguments[1]) == 'table' then
    local result = util.deepcompare(value, arguments[1], true)
    return result
  end
  return value == arguments[1]
end
local function is_true(value, arguments)
  return value == true
end

local function is_false(value, arguments)
  return value == false
end

local function truthy(value, arguments)
  return value ~= false and value ~= nil
end

local function falsy(value, arguments)
  return not truthy(value, arguments)
end

local function is_type(value, arguments, etype)
  return type(value) == etype
end

local function is_nil(value, arguments)      return is_type(value, arguments, "nil")      end
local function is_boolean(value, arguments)  return is_type(value, arguments, "boolean")  end
local function is_number(value, arguments)   return is_type(value, arguments, "number")   end
local function is_string(value, arguments)   return is_type(value, arguments, "string")   end
local function is_table(value, arguments)    return is_type(value, arguments, "table")    end
local function is_function(value, arguments) return is_type(value, arguments, "function") end
local function is_userdata(value, arguments) return is_type(value, arguments, "userdata") end
local function is_thread(value, arguments)   return is_type(value, arguments, "thread")   end

local function is_nil(value, arguments)
  return value == nil
end

local function is_boolean(value, agruments)
  return type(value) == "boolean"
end

assert:register("matcher", "true", is_true)
assert:register("matcher", "false", is_false)

assert:register("matcher", "nil", is_nil)
assert:register("matcher", "boolean", is_boolean)
assert:register("matcher", "number", is_number)
assert:register("matcher", "string", is_string)
assert:register("matcher", "table", is_table)
assert:register("matcher", "function", is_function)
assert:register("matcher", "userdata", is_userdata)
assert:register("matcher", "thread", is_thread)

assert:register("matcher", "same", same)
assert:register("matcher", "matches", matches)
assert:register("matcher", "match", matches)
assert:register("matcher", "near", near)
assert:register("matcher", "equals", equals)
assert:register("matcher", "equal", equals)
assert:register("matcher", "unique", unique)
assert:register("matcher", "truthy", truthy)
assert:register("matcher", "falsy", falsy)
