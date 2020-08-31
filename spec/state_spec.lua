describe("Tests states of the assert engine", function()

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
    assert:add_formatter(fmt1)
    local fmt2 = function(value)
        if type(value) == "number" then return "1" end
      end
    assert:add_formatter(fmt2)
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
    assert:add_formatter(fmt3)
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
    assert.is_nil(assert:get_parameter("Test_1"))
    assert.is_nil(assert:get_parameter("Test_2"))
    assert:set_parameter("Test_1", 1)
    assert:set_parameter("Test_2", 2)
    assert.are.equal(1, assert:get_parameter("Test_1"))
    assert.are.equal(2, assert:get_parameter("Test_2"))

    -- add another state level by creating a snapshot
    local snapshot2 = assert:snapshot()
    assert.are.equal(1, assert:get_parameter("Test_1"))
    assert.are.equal(2, assert:get_parameter("Test_2"))
    assert:set_parameter("Test_1", "one")
    assert:set_parameter("Test_2", nil)    -- test setting to nil
    assert.are.equal("one", assert:get_parameter("Test_1"))
    assert.is_nil(assert:get_parameter("Test_2"))

    -- revert 1 state up
    snapshot2:revert()
    assert.are.equal(1, assert:get_parameter("Test_1"))
    assert.are.equal(2, assert:get_parameter("Test_2"))

    -- revert 1 more up, to initial level
    snapshot1:revert()
    assert.is_nil(assert:get_parameter("Test_1"))
    assert.is_nil(assert:get_parameter("Test_2"))
  end)

  it("checks to see if a spy/stub is reversed", function()

    local c1, c2 = 0, 0
    local test = {
      f1 = function() c1 = c1 + 1 end,
      f2 = function() c2 = c2 + 1 end,
    }
    -- add a state level by creating a snapshot
    local snapshot1 = assert:snapshot()
    -- create spy/stub
    local s1 = spy.on(test, "f1")
    local s2 = stub(test, "f2")
    -- call them both
    test.f1()
    test.f2()
    assert.spy(test.f1).was.called(1)
    assert.spy(test.f2).was.called(1)
    assert.is_equal(1, c1)
    assert.is_equal(0, c2) -- 0, because it's a stub

    -- revert to initial level
    snapshot1:revert()
    test.f1()
    test.f2()
    -- check count is still 1 for both
    assert.spy(s1).was.called(1)
    assert.spy(s2).was.called(1)
    assert.is_equal(2, c1)
    assert.is_equal(1, c2)
  end)

end)
