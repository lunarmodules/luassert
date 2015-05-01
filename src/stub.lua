-- module will return a stub module table
local assert = require 'luassert.assert'
local spy = require 'luassert.spy'
local util = require 'luassert.util'
local stub = {}
local unpack = require 'luassert.compatibility'.unpack

function stub.new(object, key, ...)
  if object == nil and key == nil then
    -- called without arguments, create a 'blank' stub
    object = {}
    key = ""
  end
  local return_values_count = select("#", ...)
  local return_values = {...}
  assert(type(object) == "table" and key ~= nil, "stub.new(): Can only create stub on a table key, call with 2 params; table, key")
  assert(object[key] == nil or util.callable(object[key]), "stub.new(): The element for which to create a stub must either be callable, or be nil")
  local old_elem = object[key]    -- keep existing element (might be nil!)

  local fn = (return_values_count == 1 and util.callable(return_values[1]) and return_values[1])
  local defaultfunc = fn or function()
    return unpack(return_values, 1, return_values_count)
  end
  local stub_call_args = {}
  local stub_callers = {}
  local stubfunc = function(...)
    for _, args in ipairs(stub_call_args) do
      if util.deepcompare(args, {...}) then
        return stub_callers[args](...)
      end
    end
    return defaultfunc(...)
  end

  object[key] = stubfunc          -- set the stubfunction
  local s = spy.on(object, key)   -- create a spy on top of the stub function
  local spy_revert = s.revert     -- keep created revert function

  s.revert = function(self)       -- wrap revert function to restore original element
    if not self.reverted then
      spy_revert(self)
      object[key] = old_elem
      self.reverted = true
    end
    return old_elem
  end

  s.returns = function(...)
    local return_args = {...}
    local n = select('#', ...)
    defaultfunc = function()
      return unpack(return_args, 1, n)
    end
    return s
  end

  s.invokes = function(func)
    defaultfunc = function(...)
      return func(...)
    end
    return s
  end

  s.by_default = {
    returns = s.returns,
    invokes = s.invokes,
  }

  s.on_call_with = function(...)
    local match_args = {...}
    return {
      returns = function(...)
        local return_args = {...}
        local n = select('#', ...)
        table.insert(stub_call_args, match_args)
        stub_callers[match_args] = function()
          return unpack(return_args, 1, n)
        end
        return s
      end,
      invokes = function(func)
        table.insert(stub_call_args, match_args)
        stub_callers[match_args] = function(...)
          return func(...)
        end
        return s
      end
    }
  end

  return s
end

local function set_stub(state)
end

assert:register("modifier", "stub", set_stub)

return setmetatable( stub, {
    __call = function(self, ...)
      -- stub originally was a function only. Now that it is a module table
      -- the __call method is required for backward compatibility
      -- NOTE: this deviates from spy, which has no __call method
      return stub.new(...)
    end })

