-- module will not return anything, only register assertions with the main assert engine
local assert = require('luassert.assert')
local util = require 'luassert.util'
local s = require('say')

local function unique(state, list, deep)
  for k,v in pairs(list) do
    for k2, v2 in pairs(list) do
      if k ~= k2 then
        if deep and util.deepcompare(v, v2, true) then
          return false, { v, v2 }
        else
          if v == v2 then
            return false, { v, v2 }
          end
        end
      end
    end
  end
  return true
end

local function equals(state, ...)
  local args = {...}
  local argcnt = select('#',...)
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "equals", 2, tostring(argcnt) }))
  for i = 2,argcnt  do
    if args[1] ~= args[i] then return false, args end
  end
  return true
end

local function same(state, ...)
  local args = {...}
  local argcnt = select('#',...)
  assert(argcnt > 1, s("assertion.internal.argtolittle", { "same", 2, tostring(argcnt) }))
  local prev = nil
  for i = 2,argcnt  do
    if type(args[1]) == 'table' and type(args[i]) == 'table' then
      if not util.deepcompare(args[1], args[i], true) then
        return false, args
      end
    else
      if args[1] ~= args[i] then
        return false, args
      end
    end
  end
  return true
end

local function truthy(state, var)
  local val = var ~= false and var ~= nil
  return val, var
end

local function falsy(state, var)
  return not truthy(state, var), var
end

local function has_error(state, func, err_expected)
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
  local val = not status and (err_expected == nil or same(state, err_expected, err_actual))

  return val, func
end

assert:register("assertion", "same", same, "assertion.same.positive", "assertion.same.negative")
assert:register("assertion", "equals", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "equal", equals, "assertion.equals.positive", "assertion.equals.negative")
assert:register("assertion", "unique", unique, "assertion.unique.positive", "assertion.unique.negative")
assert:register("assertion", "error", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "errors", has_error, "assertion.error.positive", "assertion.error.negative")
assert:register("assertion", "truthy", truthy, "assertion.truthy.positive", "assertion.truthy.negative")
assert:register("assertion", "falsy", falsy, "assertion.falsy.positive", "assertion.falsy.negative")
