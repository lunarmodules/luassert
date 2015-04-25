-- module will return a mock module table, and will not register any assertions
local spy = require 'luassert.spy'
local stub = require 'luassert.stub'

local mock
mock = {
  new = function(object, dostub, func, self, key)
    local data_type = type(object)
    if data_type == "table" then
      if spy.is_spy(object) then
        -- this table is a function already wrapped as a spy, so nothing to do here
      else
        for k,v in pairs(object) do
          object[k] = mock.new(v, dostub, func, object, k)
        end
      end
    elseif data_type == "function" then
      if dostub then
        return stub(self, key, func)
      elseif self==nil then
        return spy.new(object)
      else
        return spy.on(self, key)
      end
    end
    return object
  end,

  revert = function(object)
    if type(object) ~= "table" then return end
    if spy.is_spy(object) then
      object:revert()
      return
    end
    for k,v in pairs(object) do
      mock.revert(v)
    end
    return object
  end
}

return setmetatable(mock, {
  __call = function(self, ...)
    -- mock originally was a function only. Now that it is a module table
    -- the __call method is required for backward compatibility
    return mock.new(...)
  end
})
