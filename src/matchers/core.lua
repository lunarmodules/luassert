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
  assert(actual, s("assertion.internal.badargtype", { "matches", stringtype, format(value) }))
  assert(init == nil or tonumber(init), s("assertion.internal.badargtype", { "matches", "number", type(arguments[2]) }))
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

local function is_truthy(value, arguments)
  return value ~= false and value ~= nil
end

local function is_falsy(value, arguments)
  return not is_truthy(value, arguments)
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

assert:register("matcher", "is_true", is_true)
assert:register("matcher", "is_false", is_false)
assert:register("matcher", "is_truthy", is_truthy)
assert:register("matcher", "is_falsy", is_falsy)

assert:register("matcher", "is_nil", is_nil)
assert:register("matcher", "is_boolean", is_boolean)
assert:register("matcher", "is_number", is_number)
assert:register("matcher", "is_string", is_string)
assert:register("matcher", "is_table", is_table)
assert:register("matcher", "is_function", is_function)
assert:register("matcher", "is_userdata", is_userdata)
assert:register("matcher", "is_thread", is_thread)

assert:register("matcher", "is_equals", equals)
assert:register("matcher", "is_equal", equals)
assert:register("matcher", "is_same", same)
assert:register("matcher", "matches", matches)
assert:register("matcher", "has_match", matches)
