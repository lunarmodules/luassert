local matcher_mt = {
  __call = function(self, ...)
    local arguments = {...}
    arguments.n = select('#',...)
    return function(value)
      return self.callback(value, arguments)
    end
  end
}

local mt = {
  __newindex = function(self, key, value)
    local matcher = {
      name = value.name,
      callback = value.callback,
    }
    setmetatable(matcher, matcher_mt)
    rawset(self, key, matcher)
  end
}

-- all registered matchers are stored in this list
return setmetatable({}, mt)
