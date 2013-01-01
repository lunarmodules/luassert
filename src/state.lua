-- maintains a state of the assert engine in a linked-list fashion
-- records; formatters, parameters, spies and stubs

local state_mt = {
      __call = function(self)
        self:revert()
      end }

local nilvalue = {} -- unique ID to refer to nil values for parameters

-- will hold the current state (1 ahead of last snapshot)
local current

-- exported module table
local state = {}

------------------------------------------------------
-- Reverts to a (specific) snapshot.
-- @param self (optional) the snapshot to revert to. If not provided, it will revert to the last snapshot.
state.revert = function(self)
  if not self then
    -- no snapshot given, so move 1 up
    self = current.previous
    if not self then
      -- top of list, no previous one, nothing to do
      return
    end
  end
  if getmetatable(self) ~= state_mt then error("Value provided is not a valid snapshot", 2) end
  
  local last = self
  while last.next do last = last.next end
  
  while last ~= self do
    -- revert formatters in 'last'
    last.formatters = {}
    -- revert parameters in 'last'
    last.parameters = {}
    -- revert spies/stubs in 'last'
    while last.spies[1] do
      last.spies[1]:revert()
      table.remove(last.spies, 1)
    end
    
    -- update state and linked list
    setmetatable(last, nil) -- invalidate as a snapshot
    last = last.previous
    last.next = nil
  end
  
  current = self.previous
end

------------------------------------------------------
-- Creates a new snapshot.
-- Current state becomes the new snapshot. Forwards the current state to 1 ahead of the new snapshot.
-- @return snapshot table
state.snapshot = function()
  local s = current
  current = setmetatable ({
    formatters = {},
    parameters = {},
    spies = {},
    previous = s,
    revert = state.revert,
  }, state_mt)
  if s then s.next = current end
  
  return s
end


--  FORMATTERS
state.addformatter = function(callback)
  table.insert(current.formatters, 1, callback)
end

state.removeformatter = function(callback)
  -- NOTE: removes only from the current state, will not traverse the linked list
  for i, v in ipairs(current.formatters) do
    if v == fmtr then
      table.remove(current.formatters, i)
      break
    end
  end
end

state.formatargument = function(val, s)
  s = s or current
  for _, fmt in ipairs(s.formatters) do
    valfmt = fmt(val)
    if valfmt ~= nil then break end
  end
  -- nothing found, check snapshot 1 up in list
  if s.previous then
    return state.formatargument(val, s.previous)
  end
  return nil -- end of list, couldn't format
end


--  PARAMETERS
state.setparameter = function(name, value)
  if value == nil then value = nilvalue end
  current.parameters[name] = value
end
state.getparameter = function(name, s)
  local val = s.parameters[name]
  if val == nil and s.previous then
    -- not found, so check 1 up in list
    return state.getparameter(name, s.previous)
  end
  if val ~= nilvalue then
    return val
  end
end

--  SPIES / STUBS
state.addspy = function(spy)
  table.insert(current.spies, 1, spy)
end

return state