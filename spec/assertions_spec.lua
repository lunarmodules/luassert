describe("Test Assertions", function()
  it("Tests backward compatible assert() functionality", function()
    local test = true
    local message = "the message"
    local third_arg = "three"
    local fourth_arg = "four"
    one, two, three, four, five = assert(test, message, third_arg, fourth_arg)
    assert(one == test and two == message and three == third_arg and 
           four == fourth_arg and five == nil, 
           "Expected input values to be outputted as well when an assertion does not fail")
  end)

  it("Checks to see if tables 1 and 2 are the same", function()
    local table1 = { derp = false}
    local table2 = { derp = false}
    assert.same(table1, table2)
  end)
  
  it("Checks the same() assertion for tables with protected metatables", function()
    local troubleSomeTable = {}
    setmetatable(troubleSomeTable, {__metatable = 0})
    assert.are.same(troubleSomeTable, troubleSomeTable)
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

  it("Checks true() assertion", function()
    assert.is.True(true)
    assert.is.Not.True(123)
    assert.is.Not.True(nil)
    assert.is.Not.True("abc")
    assert.is.Not.True(false)
    assert.is.Not.True(function() end)
  end)

  it("Checks false() assertion", function()
    assert.is.False(false)
    assert.is.Not.False(123)
    assert.is.Not.False(nil)
    assert.is.Not.False("abc")
    assert.is.Not.False(true)
    assert.is.Not.False(function() end)
  end)

  it("Checks boolean() assertion", function()
    assert.is.boolean(false)
    assert.is.boolean(true)
    assert.is.Not.boolean(123)
    assert.is.Not.boolean(nil)
    assert.is.Not.boolean("abc")
    assert.is.Not.boolean(function() end)
  end)

  it("Checks number() assertion", function()
    assert.is.number(123)
    assert.is.number(-0.345)
    assert.is.Not.number(nil)
    assert.is.Not.number("abc")
    assert.is.Not.number(true)
    assert.is.Not.number(function() end)
  end)

  it("Checks string() assertion", function()
    assert.is.string("abc")
    assert.is.Not.string(123)
    assert.is.Not.string(nil)
    assert.is.Not.string(true)
    assert.is.Not.string(function() end)
  end)

  it("Checks table() assertion", function()
    assert.is.table({})
    assert.is.Not.table("abc")
    assert.is.Not.table(123)
    assert.is.Not.table(nil)
    assert.is.Not.table(true)
    assert.is.Not.table(function() end)
  end)

  it("Checks nil() assertion", function()
    assert.is.Nil(nil)
    assert.is.Not.Nil(123)
    assert.is.Not.Nil("abc")
    assert.is.Not.Nil(true)
    assert.is.Not.Nil(function() end)
  end)

  it("Checks function() assertion", function()
    assert.is.Function(function() end)
    assert.is.Not.Function(nil)
    assert.is.Not.Function(123)
    assert.is.Not.Function("abc")
    assert.is.Not.Function(true)
  end)

  it("Checks userdata() assertion", function()
    local myfile = io.tmpfile()
    assert.is.userdata(myfile)
    myfile:close()
    assert.is.Not.userdata(nil)
    assert.is.Not.userdata(123)
    assert.is.Not.userdata("abc")
    assert.is.Not.userdata(true)
    assert.is.Not.userdata(function() end)
  end)

  it("Checks thread() assertion", function()
    local mythread = coroutine.create(function() end)
    assert.is.thread(mythread)
    assert.is.Not.thread(nil)
    assert.is.Not.thread(123)
    assert.is.Not.thread("abc")
    assert.is.Not.thread(true)
    assert.is.Not.thread(function() end)
  end)

  it("Checks '_' chaining of modifiers and assertions", function()
    assert.is_string("abc")
    assert.is_true(true)
    assert.is_not_string(123)
    assert.is_nil(nil)
    assert.is_not_nil({})
    assert.is_not_true(false)
    assert.is_not_false(true)

    -- verify that failing assertions actually fail
    assert.has_error(function() assert.is_string(1) end)
    assert.has_error(function() assert.is_true(false) end)
    assert.has_error(function() assert.is_not_string('string!') end)
    assert.has_error(function() assert.is_nil({}) end)
    assert.has_error(function() assert.is_not_nil(nil) end)
    assert.has_error(function() assert.is_not_true(true) end)
    assert.has_error(function() assert.is_not_false(false) end)
  end)

  it("Checks number of returned arguments", function()
    local fn = function()
    end

    local fn1 = function()
      return 1,2,3
    end

    local fn2 = function()
      return nil
    end

    local fn3 = function()
      return nil, nil
    end

    local fn4 = function()
      return nil, 1, nil
    end

    assert.returned_arguments(0, fn())
    assert.not_returned_arguments(2, fn1())
    assert.returned_arguments(3, fn1())

    assert.returned_arguments(1, fn2())
    assert.returned_arguments(2, fn3())
    assert.returned_arguments(3, fn4())
  end)
end)


