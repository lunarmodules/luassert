local namespace = require 'luassert.namespaces'

local errorlevel = function()
  -- find the first level, not defined in the same file as this
  -- code file to properly report the error
  local level = 1
  local info = debug.getinfo(level)
  local thisfile = (info or {}).source
  while thisfile and thisfile == (info or {}).source do
    level = level + 1
    info = debug.getinfo(level)
  end
  if level > 1 then level = level - 1 end -- deduct call to errorlevel() itself
  return level
end

local function extract_keys(tokens)
  -- find valid keys by coalescing tokens as needed, starting from the end
  local keys = {}
  local key = nil
  for i = #tokens, 1, -1 do
    local token = tokens[i]
    key = key and (token .. '_' .. key) or token
    if namespace.modifier[key] or namespace.matcher[key] then
      table.insert(keys, 1, key)
      key = nil
    end
  end

  -- if there's anything left we didn't recognize it
  if key then
    error("luassert: unknown modifier/matcher: '" .. key .."'", errorlevel())
  end

  return keys
end

local state_mt = {
  __call = function(self, ...)
    local keys = extract_keys(self.tokens)
    self.tokens = {}

    local matcher

    for _, key in ipairs(keys) do
      matcher = namespace.matcher[key] or matcher
    end

    if matcher then
      for _, key in ipairs(keys) do
        if namespace.modifier[key] then
          namespace.modifier[key].callback(self)
        end
      end

      local arguments = {...}
      arguments.n = select('#', ...) -- add argument count for trailing nils
      return function(value)
        local result = matcher.callback(value, arguments)
        return result == self.mod
      end
    else
      local arguments = {...}
      arguments.n = select('#', ...) -- add argument count for trailing nils

      for _, key in ipairs(keys) do
        if namespace.modifier[key] then
          namespace.modifier[key].callback(self, arguments)
        end
      end
    end

    return self
  end,

  __index = function(self, key)
    for token in key:lower():gmatch('[^_]+') do
      table.insert(self.tokens, token)
    end

    return self
  end
}

local match = {
  state = function() return setmetatable({mod=true, tokens={}}, state_mt) end,
}

local mt = {
  __index = function(self, key)
    return rawget(self, key) or self.state()[key]
  end,
}

return setmetatable(match, mt)
