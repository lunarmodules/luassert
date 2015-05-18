local util = {}
function util.deepcompare(t1,t2,ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  -- non-table types can be directly compared
  if ty1 ~= 'table' or ty2 ~= 'table' then return t1 == t2 end
  local mt1 = debug.getmetatable(t1)
  local mt2 = debug.getmetatable(t2)
  -- would equality be determined by metatable __eq?
  if mt1 and mt1 == mt2 and mt1.__eq then
    -- then use that unless asked not to
    if not ignore_mt then return t1 == t2 end
  else -- we can skip the deep comparison below if t1 and t2 share identity
    if t1 == t2 then return true end
  end
  for k1,v1 in pairs(t1) do
    local v2 = t2[k1]
    if v2 == nil then
      return false, {k1}
    end
    local same, crumbs = util.deepcompare(v1,v2)
    if not same then
      crumbs = crumbs or {}
      table.insert(crumbs, k1)
      return false, crumbs
    end
  end
  for k2,_ in pairs(t2) do
    -- only check wether each element has a t1 counterpart, actual comparison
    -- has been done in first loop above
    if t1[k2] == nil then return false, {k2} end
  end
  return true
end

function util.deepcopy(t)
  if type(t) ~= "table" then return t end
  local copy = {}
  for k,v in pairs(t) do
    copy[k] = util.deepcopy(v)
  end
  return copy
end

-----------------------------------------------
-- Copies arguments in a of arguments
-- @param args the arguments of which to copy
-- @param dontcare value representing don't care which matches against everything
-- @return the copy of the arguments
function util.copyargs(args, dontcare)
  local _ = (dontcare == nil and {} or dontcare)
  local copy = {}
  for k,v in pairs(args) do
    copy[k] = (v == dontcare and v or util.deepcopy(v))
  end
  return copy
end

-----------------------------------------------
-- Finds matching arguments in a saved list of arguments
-- @param argslist list of arguments from which to search
-- @param args the arguments of which to find a match
-- @param dontcare value representing don't care which matches against everything
-- @return the matching arguments if a match is found, otherwise nil
function util.matchargs(argslist, args, dontcare)
  local _ = (dontcare == nil and {} or dontcare)
  local function matches(t1, t2)
    for k1,v1 in pairs(t1) do
      local v2 = t2[k1]
      if v1 ~= _ and v2 ~= _ and (v2 == nil or not util.deepcompare(v1,v2)) then
        return false
      end
    end
    for k2,v2 in pairs(t2) do
      local v1 = t1[k2]
      if v1 ~= _ and v2 ~= _ and v1 == nil then return false end
    end
    return true
  end
  for k,v in ipairs(argslist) do
    if matches(v, args) then
      return v
    end
  end
  return nil
end

-----------------------------------------------
-- table.insert() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table into which to insert
-- @param pos (optional) position in table where to insert. NOTE: not optional if you want to insert a nil-value!
-- @param val value to insert
-- @return No return values
function util.tinsert(...)
  -- check optional POS value
  local args = {...}
  local c = select('#',...)
  local t = args[1]
  local pos = args[2]
  local val = args[3]
  if c < 3 then
    val = pos
    pos = nil
  end
  -- set length indicator n if not present (+1)
  t.n = (t.n or #t) + 1
  if not pos then
    pos = t.n
  elseif pos > t.n then
    -- out of our range
    t[pos] = val
    t.n = pos
  end
  -- shift everything up 1 pos
  for i = t.n, pos + 1, -1 do
    t[i]=t[i-1]
  end
  -- add element to be inserted
  t[pos] = val
end
-----------------------------------------------
-- table.remove() replacement that respects nil values.
-- The function will use table field 'n' as indicator of the
-- table length, if not set, it will be added.
-- @param t table from which to remove
-- @param pos (optional) position in table to remove
-- @return No return values
function util.tremove(t, pos)
  -- set length indicator n if not present (+1)
  t.n = t.n or #t
  if not pos then
    pos = t.n
  elseif pos > t.n then
    -- out of our range
    t[pos] = nil
    return
  end
  -- shift everything up 1 pos
  for i = pos, t.n do
    t[i]=t[i+1]
  end
  -- set size, clean last
  t[t.n] = nil
  t.n = t.n - 1
end

-----------------------------------------------
-- Checks an element to be callable.
-- The type must either be a function or have a metatable
-- containing an '__call' function.
-- @param object element to inspect on being callable or not
-- @return boolean, true if the object is callable
function util.callable(object)
  return type(object) == "function" or type((debug.getmetatable(object) or {}).__call) == "function"
end

return util
