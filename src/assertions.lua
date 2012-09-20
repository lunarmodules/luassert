-- module will not return anything, only register assertions with the main assert engine

-- assertions take 2 parameters;
-- 1) state
-- 2) arguments list. The list has a member 'n' with the argument count to check for trailing nils
-- returns; boolean; whether assertion passed

local assert = require('luassert.assert')
local util = require 'luassert.util'
local s = require('say')

local function unique(state, arguments)
  local list = arguments[1]
  local deep = arguments[2]
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

local function equals(state, arguments)
  local argcnt = arguments.n
  assert(type(argcnt) == "number", "Equals: argument table provided has no length indicator; 'n'")
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "equals", 2, tostring(argcnt) }))
  for i = 2,argcnt  do
    if arguments[1] ~= arguments[i] then return false end
  end
  return true
end

local function same(state, arguments)
  local argcnt = arguments.n
  assert(type(argcnt) == "number", "Same: argument table provided has no length indicator; 'n'")
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "same", 2, tostring(argcnt) }))
  local prev = nil
  for i = 2,argcnt  do
    if type(arguments[1]) == 'table' and type(arguments[i]) == 'table' then
      if not util.deepcompare(arguments[1], arguments[i], true) then
        return false
      end
    else
      if arguments[1] ~= arguments[i] then
        return false
      end
    end
  end
  return true
end

local function truthy(state, arguments)
  return arguments[1] ~= false and arguments[1] ~= nil
end

local function falsy(state, arguments)
  return not truthy(state, arguments)
end

local function has_error(state, arguments)
  local func = arguments[1]
  local err_expected = arguments[2]
  
  assert(type(func) == "function", s("assertion.internal.badargtype", { "error", "function", type(func) }))
  local err_actual = nil
  --must swap error functions to get the actual error message
  local old_error = error
  error = function(err)
    err_actual = err
    return old_error(err)
  end
  local status = pcall(func)
  error = old_error
  local val = not status and (err_expected == nil or same(state, {err_expected, err_actual, ["n"] = 2}))

  return val
end

assert:register("assertion", "same", same, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "equals", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "equal", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "unique", unique, "assertion.unique.positive", "assertion.unique.negative")
assert:register("assertion", "error", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "errors", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "truthy", truthy, "assertion.truthy.positive", "assertion.truthy.negative")
assert:register("assertion", "falsy", falsy, "assertion.falsy.positive", "assertion.falsy.negative")
