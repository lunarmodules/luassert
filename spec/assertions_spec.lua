describe("Test Assertions", function()
  it("Checks to see if tables 1 and 2 are the same", function()
    local table1 = { derp = false}
    local table2 = { derp = false}
    assert.same(table1, table2)
  end)

  it("Checks same() assertion to handle nils properly", function()
    assert.is.error(function() assert.same(nil) end)  -- minimum 2 arguments
    assert.same(nil, nil)
    assert.is_not.same("a string", nil)
    assert.is_not.same(nil, "a string")
  end)

  it("Checks to see if tables 1 and 2 are equal", function()
    local table1 = { derp = false}
    local table2 = table1
    assert.equals(table1, table2)
  end)

  it("Checks equals() assertion to handle nils properly", function()
    assert.is.error(function() assert.equals(nil) end)  -- minimum 2 arguments
    assert.equals(nil, nil)
    assert.is_not.equals("a string", nil)
    assert.is_not.equals(nil, "a string")
  end)

  it("Checks to see if table1 only contains unique elements", function()
    local table2 = { derp = false}
    local table3 = { derp = true }
    local table1 = {table2,table3}
    local tablenotunique = {table2,table2}
    assert.is.unique(table1)
    assert.is_not.unique(tablenotunique)
  end)

  it("Ensures the is operator doesn't change the behavior of equals", function()
    assert.is.equals(true, true)
  end)

  it("Ensures the is_not operator does change the behavior of equals", function()
    assert.is_not.equals(true, false)
  end)

  it("Ensures that error only throws an error when the first argument function does not throw an error", function()
    local test_function = function() error("test") end
    assert.has.error(test_function)
    assert.has.error(test_function, "test")
    assert.has_no.errors(test_function, "derp")
  end)

  it("Checks to see if var is truthy", function()
    assert.is_not.truthy(nil)
    assert.is.truthy(true)
    assert.is.truthy({})
    assert.is.truthy(function() end)
    assert.is.truthy("")
    assert.is_not.truthy(false)
    assert.error(function() assert.truthy(false) end)
  end)

  it("Checks to see if var is falsy", function()
    assert.is.falsy(nil)
    assert.is_not.falsy(true)
    assert.is_not.falsy({})
    assert.is_not.falsy(function() end)
    assert.is_not.falsy("")
    assert.is.falsy(false)
  end)
  
  it("tests the error outputted for same() with multiple arguments, to report the failing value", function()
    local old_assertformat = assert.format
    local arg1, arg2
    assert.format = function(self, args)
      args = old_assertformat(self, args)
      arg1 = args[1]      
      arg2 = args[2]      
      return args
    end
    pcall(assert.are.same,"ok", "ok","not ok")
    assert.format = old_assertformat
    assert.are_not.equal(arg1, arg2)
  end)

  it("Ensures the Not operator does change the behavior of equals", function()
    assert.is.Not.equal(true, false)
  end)

end)


