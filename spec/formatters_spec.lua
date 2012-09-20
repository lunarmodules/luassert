local assert = require("luassert")

local function returnnils()
  -- force the return of nils in an argument array
  local a,b
  return a, b, "this is not nil"
end

describe("Test Formatters", function()
  it("Checks to see if types are returned as strings", function()
    assert.is.same(type(assert:format({ "a string" })[1]), "string")
    assert.is.same(type(assert:format({ true })[1]), "string")
    assert.is.same(type(assert:format({ 1234 })[1]), "string")
    assert.is.same(type(assert:format({ function() end })[1]), "string")
    assert.is.same(type(assert:format({ returnnils() })[1]), "string")
  end)

  it("Checks to see if empty table is returned empty", function()
    local t = {}
    local formatted = assert:format(t)
    assert.equals(type(formatted), "table")
    assert.equals(next(formatted), nil)
  end)

  it("Checks to see if table containing nils is returned with same number of entries #test", function()
    local t = { returnnils() }
    formatted = assert:format(t, 3)
    assert.equals(#t,3)
    assert.is.same(type(formatted[1]), "string")
    assert.is.same(type(formatted[2]), "string")
    assert.is.same(type(formatted[3]), "string")
    assert.is.same(type(formatted[4]), "nil")
  end)
end)
