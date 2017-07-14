-- busted helper file to prevent crashes on LuaJIT ffi module being
-- garbage collected due to Busted cleaning up the test enviornment
--
-- usage:
--   busted --helper=spec/helper.lua

-- only apply when we're running LuaJIT
local isJit = (tostring(assert):match('builtin') ~= nil)

if isJit then
  -- pre-load the ffi module, such that it becomes part of the environment
  -- and Busted will not try to GC and reload it. The ffi is not suited
  -- for that and will occasionally segfault if done so.
  local ffi = require "ffi"

  -- Now patch ffi.cdef to only be called once with each definition, as it
  -- will error on re-registering.
  local old_cdef = ffi.cdef
  local exists = {}
  ffi.cdef = function(def)
    if exists[def] then return end
    exists[def] = true
    return old_cdef(def)
  end
end
