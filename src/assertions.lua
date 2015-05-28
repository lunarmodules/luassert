-- module will not return anything, only register assertions with the main assert engine

-- assertions take 2 parameters;
-- 1) state
-- 2) arguments list. The list has a member 'n' with the argument count to check for trailing nils
-- 3) level The level of the error position relative to the called function
-- returns; boolean; whether assertion passed

local assert = require('luassert.assert')
local astate = require ('luassert.state')
local util = require ('luassert.util')
local s = require('say')

local function format(val)
  return astate.format_argument(val) or tostring(val)
end

local function set_failure_message(state, message)
  if message ~= nil then
    state.failure_message = message
  end
end

local function unique(state, arguments, level)
  local list = arguments[1]
  local deep
  local argcnt = arguments.n
  if type(arguments[2]) == "boolean" or (arguments[2] == nil and argcnt > 2) then
    deep = arguments[2]
    set_failure_message(state, arguments[3])
  else
    if type(arguments[3]) == "boolean" then
      deep = arguments[3]
    end
    set_failure_message(state, arguments[2])
  end
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

local function near(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 2, s("assertion.internal.argtolittle", { "near", 3, tostring(argcnt) }), level)
  local expected = tonumber(arguments[1])
  local actual = tonumber(arguments[2])
  local tolerance = tonumber(arguments[3])
  local numbertype = "number or object convertible to a number"
  assert(expected, s("assertion.internal.badargtype", { "near", numbertype, format(arguments[1]) }), level)
  assert(actual, s("assertion.internal.badargtype", { "near", numbertype, format(arguments[2]) }), level)
  assert(tolerance, s("assertion.internal.badargtype", { "near", numbertype, format(arguments[3]) }), level)
  -- switch arguments for proper output message
  util.tinsert(arguments, 1, util.tremove(arguments, 2))
  arguments[3] = tolerance
  arguments.nofmt = arguments.nofmt or {}
  arguments.nofmt[3] = true
  set_failure_message(state, arguments[4])
  return (actual >= expected - tolerance and actual <= expected + tolerance)
end

local function matches(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "matches", 2, tostring(argcnt) }), level)
  local pattern = arguments[1]
  local actual = nil
  if util.hastostring(arguments[2]) or type(arguments[2]) == "number" then
    actual = tostring(arguments[2])
  end
  local err_message
  for i=3,argcnt,1 do
    if arguments[i] and type(arguments[i]) ~= "boolean" and not tonumber(arguments[i]) then
      err_message = util.tremove(arguments, i)
      break
    end
  end
  local init = arguments[3]
  local plain = arguments[4]
  local stringtype = "string or object convertible to a string"
  assert(type(pattern) == "string", s("assertion.internal.badargtype", { "matches", "string", type(arguments[1]) }), level)
  assert(actual, s("assertion.internal.badargtype", { "matches", stringtype, format(arguments[2]) }), level)
  assert(init == nil or tonumber(init), s("assertion.internal.badargtype", { "matches", "number", type(arguments[3]) }), level)
  -- switch arguments for proper output message
  util.tinsert(arguments, 1, util.tremove(arguments, 2))
  set_failure_message(state, err_message)
  return (actual:find(pattern, init, plain) ~= nil)
end

local function equals(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "equals", 2, tostring(argcnt) }), level)
  local result =  arguments[1] == arguments[2]
  -- switch arguments for proper output message
  util.tinsert(arguments, 1, util.tremove(arguments, 2))
  set_failure_message(state, arguments[3])
  return result
end

local function same(state, arguments, level)
  local level = (level or 1) + 1
  local argcnt = arguments.n
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "same", 2, tostring(argcnt) }), level)
  if type(arguments[1]) == 'table' and type(arguments[2]) == 'table' then
    local result, crumbs = util.deepcompare(arguments[1], arguments[2], true)
    -- switch arguments for proper output message
    util.tinsert(arguments, 1, util.tremove(arguments, 2))
    arguments.fmtargs = arguments.fmtargs or {}
    arguments.fmtargs[1] = { crumbs = crumbs }
    arguments.fmtargs[2] = { crumbs = crumbs }
    set_failure_message(state, arguments[3])
    return result
  end
  local result = arguments[1] == arguments[2]
  -- switch arguments for proper output message
  util.tinsert(arguments, 1, util.tremove(arguments, 2))
  set_failure_message(state, arguments[3])
  return result
end

local function truthy(state, arguments, level)
  set_failure_message(state, arguments[2])
  return arguments[1] ~= false and arguments[1] ~= nil
end

local function falsy(state, arguments, level)
  return not truthy(state, arguments, level)
end

local function has_error(state, arguments, level)
  local level = (level or 1) + 1
  local func = arguments[1]
  local err_expected = arguments[2]
  local failure_message = arguments[3]
  assert(util.callable(func), s("assertion.internal.badargtype", { "error", "function, or callable object", type(func) }), level)
  local ok, err_actual = pcall(func)
  if type(err_actual) == 'string' then
    -- remove 'path/to/file:line: ' from string
    err_actual = err_actual:gsub('^.-:%d+: ', '', 1)
  end
  arguments.nofmt = {}
  arguments.n = 2
  arguments[1] = (ok and '(no error)' or err_actual)
  arguments[2] = (err_expected == nil and '(error)' or err_expected)
  arguments.nofmt[1] = ok
  arguments.nofmt[2] = (err_expected == nil)
  set_failure_message(state, failure_message)

  if ok or err_expected == nil then
    return not ok
  end
  if type(err_expected) == 'string' then
    -- err_actual must be (convertible to) a string
    if util.hastostring(err_actual) then
      err_actual = tostring(err_actual)
    end
    if type(err_actual) == 'string' then
      return err_expected == err_actual
    end
  elseif type(err_expected) == 'number' then
    if type(err_actual) == 'string' then
      return tostring(err_expected) == tostring(tonumber(err_actual))
    end
  end
  return same(state, {err_expected, err_actual, ["n"] = 2})
end

local function is_true(state, arguments, level)
  util.tinsert(arguments, 2, true)
  set_failure_message(state, arguments[3])
  return arguments[1] == arguments[2]
end

local function is_false(state, arguments, level)
  util.tinsert(arguments, 2, false)
  set_failure_message(state, arguments[3])
  return arguments[1] == arguments[2]
end

local function is_type(state, arguments, level, etype)
  util.tinsert(arguments, 2, "type " .. etype)
  arguments.nofmt = arguments.nofmt or {}
  arguments.nofmt[2] = true
  set_failure_message(state, arguments[3])
  return arguments.n > 1 and type(arguments[1]) == etype
end

local function returned_arguments(state, arguments, level)
  arguments[1] = tostring(arguments[1])
  arguments[2] = tostring(arguments.n - 1)
  arguments.nofmt = arguments.nofmt or {}
  arguments.nofmt[1] = true
  arguments.nofmt[2] = true
  if arguments.n < 2 then arguments.n = 2 end
  return arguments[1] == arguments[2]
end

local function set_message(state, arguments, level)
  state.failure_message = arguments[1]
end

local function is_boolean(state, arguments, level)  return is_type(state, arguments, level, "boolean")  end
local function is_number(state, arguments, level)   return is_type(state, arguments, level, "number")   end
local function is_string(state, arguments, level)   return is_type(state, arguments, level, "string")   end
local function is_table(state, arguments, level)    return is_type(state, arguments, level, "table")    end
local function is_nil(state, arguments, level)      return is_type(state, arguments, level, "nil")      end
local function is_userdata(state, arguments, level) return is_type(state, arguments, level, "userdata") end
local function is_function(state, arguments, level) return is_type(state, arguments, level, "function") end
local function is_thread(state, arguments, level)   return is_type(state, arguments, level, "thread")   end

assert:register("modifier", "message", set_message)
assert:register("assertion", "true", is_true, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "false", is_false, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "boolean", is_boolean, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "number", is_number, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "string", is_string, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "table", is_table, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "nil", is_nil, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "userdata", is_userdata, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "function", is_function, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "thread", is_thread, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "returned_arguments", returned_arguments, "assertion.returned_arguments.positive", "assertion.returned_arguments.negative")

assert:register("assertion", "same", same, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "matches", matches, "assertion.matches.positive", "assertion.matches.negative")
assert:register("assertion", "match", matches, "assertion.matches.positive", "assertion.matches.negative")
assert:register("assertion", "near", near, "assertion.near.positive", "assertion.near.negative")
assert:register("assertion", "equals", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "equal", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "unique", unique, "assertion.unique.positive", "assertion.unique.negative")
assert:register("assertion", "error", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "errors", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "truthy", truthy, "assertion.truthy.positive", "assertion.truthy.negative")
assert:register("assertion", "falsy", falsy, "assertion.falsy.positive", "assertion.falsy.negative")
