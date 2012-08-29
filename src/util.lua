local util = {}
function util.deepcompare(t1,t2,ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
    local v2 = t2[k1]
    if v2 == nil or not util.deepcompare(v1,v2) then return false end
  end
  for k2,_ in pairs(t2) do
    -- only check wether each element has a t1 counterpart, actual comparison
    -- has been done in first loop above
    if t1[k2] == nil then return false end
  end
  return true
end
return util
