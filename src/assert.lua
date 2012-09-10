local s = require 'say'

local __assertion_meta = {
  __call = function(self, ...)
    local state = self.state
    local val = self.callback(state, ...)
    local data_type = type(val)

    if data_type == "boolean" then
      if val ~= state.mod then
        if state.mod then
          error(s(self.positive_message, assert:format({...})) or "assertion failed!", 2)
        else
          error(s(self.negative_message, assert:format({...})) or "assertion failed!", 2)
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
    if rawget(self.parent, "modifier")[key] then
      rawget(self.parent, "modifier")[key].state = self
      return self(nil,
      rawget(self.parent, "modifier")[key]
      )
    elseif rawget(self.parent, "assertion")[key] then
      rawget(self.parent, "assertion")[key].state = self
      return rawget(self.parent, "assertion")[key]
    else
      error("luassert: unknown modifier/assertion: '" .. tostring(key).."'", 2)
    end
  end

}

local obj = {
  -- list of registered assertions
  assertion = {},

  state = function(obj) return setmetatable({mod=true, payload=nil, parent=obj}, __state_meta) end,

  -- list of registered modifiers
  modifier = {},

  -- list of registered formatters
  formatter = {},

  -- registers a function in namespace
  register = function(self, namespace, name, callback, positive_message, negative_message)
    -- register
    local lowername = name:lower()
    if not self[namespace] then
      self[namespace] = {}
    end
    self[namespace][lowername] = setmetatable({
      callback = callback,
      name = lowername,
      positive_message=positive_message,
      negative_message=negative_message
    }, __assertion_meta)
  end,

  -- registers a formatter
  -- a formatter takes a single argument, and converts it to a string, or returns nil if it cannot format the argument
  addformatter = function(self, callback)
    table.insert(self.formatter, callback)
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
    if #args == 0 then return end

    for i, val in ipairs(args) do
      local valfmt = nil
      for n, fmt in ipairs(self.formatter) do
        valfmt = fmt(val)
        if valfmt ~= nil then break end
      end
      if valfmt == nil then valfmt = tostring(val) end -- no formatter found
      args[i] = valfmt
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

  __index = function(self, key) return self.state(self)[key] end,

}

return setmetatable(obj, __meta)
