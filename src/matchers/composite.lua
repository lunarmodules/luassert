local assert = require('luassert.assert')
local match = require ('luassert.match')
local s = require('say')

local function none(state, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "none", 1, tostring(argcnt) }))
  for i = 1, argcnt do
    assert(match.is_matcher(arguments[i]), s("assertion.internal.badargtype", { "none", "matcher", type(arguments[i]) }))
  end

  return function(value)
    for _, matcher in ipairs(arguments) do
      if matcher(value) then
        return false
      end
    end
    return true
  end
end

local function any(state, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "any", 1, tostring(argcnt) }))
  for i = 1, argcnt do
    assert(match.is_matcher(arguments[i]), s("assertion.internal.badargtype", { "any", "matcher", type(arguments[i]) }))
  end

  return function(value)
    for _, matcher in ipairs(arguments) do
      if matcher(value) then
        return true
      end
    end
    return false
  end
end

local function all(state, arguments)
  local argcnt = arguments.n
  assert(argcnt > 0, s("assertion.internal.argtolittle", { "all", 1, tostring(argcnt) }))
  for i = 1, argcnt do
    assert(match.is_matcher(arguments[i]), s("assertion.internal.badargtype", { "all", "matcher", type(arguments[i]) }))
  end

  return function(value)
    for _, matcher in ipairs(arguments) do
      if not matcher(value) then
        return false
      end
    end
    return true
  end
end

assert:register("matcher", "none_of", none)
assert:register("matcher", "any_of", any)
assert:register("matcher", "all_of", all)
