describe("Tests dealing with spies", function()
  local test = {}

  before_each(function()
    test = {key = function()
      return "derp"
    end}
  end)
--[[
  it("checks if a spy actually executes the internal function", function()
    spy.on(test, "key")
    assert(test.key() == "derp")
  end)
]]
  it("checks to see if spy keeps track of arguments", function()

    spy.on(test, "key")

    test.key("derp")
    assert.spy(test.key).was.called_with("derp")
    assert.errors(function() assert.spy(test.key).was.called_with("herp") end)
  end)

  it("checks to see if spy keeps track of number of calls", function()
     spy.on(test, "key")
     test.key()
     test.key("test")
     assert.spy(test.key).was.called(2)
  end)
  
  it("checks called() and called_with() assertions", function()
    local s = spy.new()

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called()
    assert.spy(s).was.called(2) -- twice!
    assert.spy(s).was_not.called(3)
    assert.spy(s).was_not.called_with({1, 2, 3}) -- mind the accolades
    assert.spy(s).was.called_with(1, 2, 3)
  end)
  
end)
