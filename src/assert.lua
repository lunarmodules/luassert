local s = require 'say'

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

-- list of namespaces
local namespace = {}

local __assertion_meta = {
  __call = function(self, ...)
    local state = self.state
    local arguments = {...}
    arguments.n = select('#',...)  -- add argument count for trailing nils
    local val = self.callback(state, arguments)
    local data_type = type(val)

    if data_type == "boolean" then
      if val ~= state.mod then
        if state.mod then
          error(s(self.positive_message, assert:format(arguments)) or "assertion failed!", errorlevel())
        else
          error(s(self.negative_message, assert:format(arguments)) or "assertion failed!", errorlevel())
        end
      else
        return state
      end
    end
    return val
  end
}

local __state_meta = {

  __call = function(self, payload, callback)
    self.payload = payload or rawget(self, "payload")
    if callback then callback(self) end
    return self
  end,

  __index = function(self, key)
    key = key:lower()
    if namespace.modifier[key] then
      namespace.modifier[key].state = self
      return self(nil, namespace.modifier[key])
    elseif namespace.assertion[key] then
      namespace.assertion[key].state = self
      return namespace.assertion[key]
    else
      error("luassert: unknown modifier/assertion: '" .. tostring(key).."'", errorlevel())
    end
  end

}

local obj = {
  state = function() return setmetatable({mod=true, payload=nil}, __state_meta) end,

  -- list of registered formatters
  formatter = {},

  -- registers a function in namespace
  register = function(self, nspace, name, callback, positive_message, negative_message)
    -- register
    local lowername = name:lower()
    if not namespace[nspace] then
      namespace[nspace] = {}
    end
    namespace[nspace][lowername] = setmetatable({
      callback = callback,
      name = lowername,
      positive_message=positive_message,
      negative_message=negative_message
    }, __assertion_meta)
  end,

  -- registers a formatter
  -- a formatter takes a single argument, and converts it to a string, or returns nil if it cannot format the argument
  addformatter = function(self, callback)
    table.insert(self.formatter, 1, callback)
  end,
  
  -- unregisters a formatter
  removeformatter = function(self, formatter)
    for i, v in ipairs(self.formatter) do
      if v == formatter then
        table.remove(self.formatter, i)
        break
      end
    end
  end,
  
  format = function(self, args)
    -- args.n specifies the number of arguments in case of 'trailing nil' arguments which get lost
    local nofmt = args.nofmt or {}  -- arguments in this list should not be formatted
    for i = 1, (args.n or #args) do -- cannot use pairs because table might have nils
      if not nofmt[i] then
        local val = args[i]
        local valfmt = nil
        for n, fmt in ipairs(self.formatter) do
          valfmt = fmt(val)
          if valfmt ~= nil then break end
        end
        if valfmt == nil then valfmt = tostring(val) end -- no formatter found
        args[i] = valfmt
      end
    end
    return args
  end

}

local __meta = {

  __call = function(self, bool, message)
    if not bool then
      error(message or "assertion failed!", 2)
    end
    return bool
  end,

  __index = function(self, key) return self.state()[key] end,

}

return setmetatable(obj, __meta)
