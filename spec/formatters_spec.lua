local assert

local function returnnils()
  -- force the return of nils in an argument array
  local a,b
  return a, b, "this is not nil"
end

describe("Test Formatters", function()
  setup(function()
    -- must reload luassert with _TEST defined to test private elements
    for k,v in pairs(package.loaded) do 
      if k:find("luassert") == 1 then package.loaded[k] = false end 
    end    
    assert = require("luassert")
    require('luassert.spy')
    require('luassert.mock')
  end)

  local snapshot

  before_each(function()
    snapshot = assert:snapshot()
  end)

  after_each(function()
    snapshot:revert()
  end)
  
  it("Checks to see if types are returned as strings", function()
    assert.is.same(assert:format({ "a string", ["n"] = 1 })[1], "(string) 'a string'")
    assert.is.same(assert:format({ true, ["n"] = 1 })[1], "(boolean) true")
    assert.is.same(assert:format({ 1234, ["n"] = 1 })[1], "(number) 1234")
    assert.is.same(assert:format({ returnnils(), ["n"] = 3 })[1], "(nil)")
    local f = function() end
    local expected = tostring(f)
    assert.is.same(assert:format({ f, ["n"] = 1 })[1]:sub(1, #expected), expected)
  end)

  it("Checks to see if tables are recursively serialized", function()
    assert.is.same(assert:format({ {}, ["n"] = 1 })[1], "(table): { }")
    assert.is.same(assert:format({ { 2, 3, 4, [-5] = 7}, ["n"] = 1 })[1], [[(table): {
  [1] = 2
  [2] = 3
  [3] = 4
  [-5] = 7 }]])
    assert.is.same(assert:format({ { 1, ["k1"] = "v1", ["k2"] = "v2"}, ["n"] = 1 })[1], [[(table): {
  [1] = 1
  [k1] = 'v1'
  [k2] = 'v2' }]])
    assert.is.same(assert:format({ { "{\n }\n" }, ["n"] = 1 })[1], [[(table): {
  [1] = '{
 }
' }]])
  end)

  it("Checks to see if TableFormatLevel parameter limits table formatting depth", function()
    assert.is.same(assert:format({ { { { { 1 } } } }, ["n"] = 1 })[1], [[(table): {
  [1] = {
    [1] = {
      [1] = { ... more } } } }]])
    assert.is.same(assert:format({ { { { } } }, ["n"] = 1 })[1], [[(table): {
  [1] = {
    [1] = { } } }]])
    assert:set_parameter("TableFormatLevel", 0)
    assert.is.same(assert:format({ { }, ["n"] = 1 })[1], "(table): { }")
    assert.is.same(assert:format({ { 1 }, ["n"] = 1 })[1], "(table): { ... more }")
  end)

  it("Checks to see if table with 0 count is returned empty/0-count", function()
    local t = { ["n"] = 0 }
    local formatted = assert:format(t)
    assert.equals(type(formatted), "table")
    formatted.n = nil
    assert.equals(next(formatted), nil)
  end)

  it("Checks to see if empty table is returned empty", function()
    local t = {}
    local formatted = assert:format(t)
    assert.equals(type(formatted), "table")
    assert.equals(next(formatted), nil)
  end)

  it("Checks to see if table containing nils is returned with same number of entries #test", function()
    local t = { returnnils(), ["n"] = 3 }
    formatted = assert:format(t)
    assert.is.same(type(formatted[1]), "string")
    assert.is.same(type(formatted[2]), "string")
    assert.is.same(type(formatted[3]), "string")
    assert.is.same(type(formatted[4]), "nil")
  end)
  
  it("checks arguments not being formatted if set to do so", function()
    local arg1 = "argument1"
    local arg2 = "argument2"
    local arguments = { arg1, arg2 , ["n"] = 2}
    arguments.nofmt = { true } -- first arg not to be formatted
    arguments = assert:format(arguments)
    assert.is.same(arg1, arguments[1])
  end)
  
  it("checks extra formatters inserted to be called first", function()
    local expected = "formatted result"
    local f = function(value)
      if type(value) == "string" then
        return expected
      end
    end
    local s = spy.new(f)
    
    assert:add_formatter(s)
    assert.are_equal(expected, assert:format({"some string"})[1])
    assert.spy(s).was.called(1)
    assert:remove_formatter(s)
  end)
  
end)
