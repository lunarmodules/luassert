local s = require 'say'
local obj

-- list of namespaces
local namespace = {}
-- list of registered formatters
local formatter = {}

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
          error(s(self.positive_message, obj:format(arguments)) or "assertion failed!", errorlevel())
        else
          error(s(self.negative_message, obj:format(arguments)) or "assertion failed!", errorlevel())
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
    -- chcek whether its a chained call using '_' and handle
    local rev = key:reverse()
    local pos = #key
    while pos do
      -- start with full key
      local skey = key:sub(1,pos)
      local nextpart = key:sub(#skey + 2,-1)
      if namespace.modifier[skey] or namespace.assertion[skey] then
          if nextpart ~= "" then
            -- inital modifier extracted, now call on remainder of chain
            local _ = self[nextpart]   -- just index self to update state
          end
          -- update key to only be the extracted initial modifier on chain, will be executed below
          key = skey
          break
      else
        -- work back from the end -> one '_' at a time
        local n = rev:find("_", #key - (pos - 1))
        if n then
          pos = #key - n
        else
          break
        end
      end
    end
    -- execute modifiers and assertions (unchained from '_')
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

obj = {
  state = function() return setmetatable({mod=true, payload=nil}, __state_meta) end,

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
    table.insert(formatter, 1, callback)
  end,
  
  -- unregisters a formatter
  removeformatter = function(self, fmtr)
    for i, v in ipairs(formatter) do
      if v == fmtr then
        table.remove(formatter, i)
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
        for _, fmt in ipairs(formatter) do
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

  __index = function(self, key)
    return rawget(self, key) or self.state()[key]
  end,

}

-- export locals to test alias
if _TEST then
  obj._formatter = formatter
end

return setmetatable(obj, __meta)
