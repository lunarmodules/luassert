describe("Tests states of the assert engine", function()
  
--[[  local printformatters = function(s, desc)
    print("\n" .. tostring(desc))
    while s.previous do s = s.previous end
    local i = 1
    while true do
      print("level ",i," has ", #s.formatters, "formatters")
      i = i + 1
      s = s.next
      if not s then break end
    end
  end
]]
  
  it("checks levels created/reverted", function()
    local start = assert:snapshot()
    assert.is_nil(start.next)
    
    local snapshot1 = assert:snapshot()
    assert.is.table(start.next)
    assert.are.equal(start.next, snapshot1)
    assert.are.equal(start, snapshot1.previous)
    assert.is_nil(snapshot1.next)
    
    local snapshot2 = assert:snapshot()
    assert.is.table(snapshot1.next)
    assert.are.equal(snapshot2, snapshot1.next)
    assert.are.equal(snapshot2.previous, snapshot1)
    assert.is_nil(snapshot2.next)
    
    snapshot2:revert()
    assert.is.table(start.next)
    assert.are.equal(start.next, snapshot1)
    assert.are.equal(start, snapshot1.previous)
    assert.is_nil(snapshot1.next)
    
    snapshot1:revert()
    assert.is_nil(start.next)
  end)
  
  it("checks to see if a formatter is reversed", function()

    -- add a state level by creating a snapshot
    local snapshot1 = assert:snapshot()
    -- register extra formatters
    local fmt1 = function(value)
        if type(value) == "string" then return "ok" end
      end
    assert:addformatter(fmt1)
    local fmt2 = function(value)
        if type(value) == "number" then return "1" end
      end
    assert:addformatter(fmt2)
    -- check formatters
    assert.are.equal(#snapshot1.formatters, 2)
    assert.are.equal(snapshot1.formatters[2], fmt1)
    assert.are.equal(snapshot1.formatters[1], fmt2)
    assert.are.equal("ok", assert:format({"some value"})[1])
    assert.are.equal("1", assert:format({123})[1])
    
    -- add another state level by creating a snapshot
    local snapshot2 = assert:snapshot()
    -- register extra formatter
    local fmt3 = function(value)
        if type(value) == "number" then return "2" end
      end
    assert:addformatter(fmt3)
    assert.are.equal(#snapshot2.formatters, 1)
    assert.are.equal(snapshot2.formatters[1], fmt3)
    -- check formatter newest level
    assert.are.equal("2", assert:format({123})[1])
    -- check formatter previous level
    assert.are.equal("ok", assert:format({"some value"})[1])
    -- check formatter initial level
    assert.are.equal("(boolean) true", assert:format({true})[1])
    
    -- revert 1 state up
    snapshot2:revert()
    assert.is_nil(snapshot1.next)
    assert.are.equal(2, #snapshot1.formatters)
    -- check formatter reverted level
    assert.are.equal("1", assert:format({123})[1])
    -- check formatter unchanged level
    assert.are.equal("ok", assert:format({"some value"})[1])
    -- check formatter unchanged level
    assert.are.equal("(boolean) true", assert:format({true})[1])
    
    -- revert 1 more up, to initial level
    snapshot1:revert()
    assert.are.equal("(number) 123", assert:format({123})[1])
    assert.are.equal("(string) 'some value'", assert:format({"some value"})[1])
    assert.are.equal("(boolean) true", assert:format({true})[1])  
  end)

  it("checks to see if a parameter is reversed", function()

    -- add a state level by creating a snapshot
    local snapshot1 = assert:snapshot()
    assert.is_nil(assert:getparameter("Test_1"))
    assert.is_nil(assert:getparameter("Test_2"))
    assert:setparameter("Test_1", 1)
    assert:setparameter("Test_2", 2)
    assert.are.equal(1, assert:getparameter("Test_1"))
    assert.are.equal(2, assert:getparameter("Test_2"))
    
    -- add another state level by creating a snapshot
    local snapshot2 = assert:snapshot()
    assert.are.equal(1, assert:getparameter("Test_1"))
    assert.are.equal(2, assert:getparameter("Test_2"))
    assert:setparameter("Test_1", "one")
    assert:setparameter("Test_2", nil)    -- test setting to nil
    assert.are.equal("one", assert:getparameter("Test_1"))
    assert.is_nil(assert:getparameter("Test_2"))
    
    -- revert 1 state up
    snapshot2:revert()
    assert.are.equal(1, assert:getparameter("Test_1"))
    assert.are.equal(2, assert:getparameter("Test_2"))
    
    -- revert 1 more up, to initial level
    snapshot1:revert()
    assert.is_nil(assert:getparameter("Test_1"))
    assert.is_nil(assert:getparameter("Test_2"))
  end)

end)
