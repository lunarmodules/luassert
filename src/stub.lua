-- module will return a single stub function, no table nor register any assertions
local spy = require 'luassert.spy'

return function(self, key)
  self[key] = spy.new(function() end)
  return self[key]
end
