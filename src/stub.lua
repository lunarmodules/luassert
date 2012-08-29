-- module will return a single stub function, no table nor register any assertions
local spy = require 'luassert.spy'

return function(self, key, func)
  self[key] = spy:new(func)
  return self[key]
end
