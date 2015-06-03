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

    if type(jit) == "table" then
      loadstring([[
        local assert = require 'luassert'
        assert.same(0ULL, 0)
        assert.same(0, 0ULL)
        assert.same({0ULL}, {0})
        assert.same({0}, {0ULL})
      ]])()
    end
  end)

  it("Checks to see if tables 1 and 2 are not the same", function()
    local table1 = { derp = false}
    local table2 = { derp = true}
    assert.is_not.same(table1, table2)
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

  it("Checks same() assertion to handle recursive tables", function()
    local t1 = { k1 = 1, k2 = 2, k3 = t1 }
    local t2 = { k1 = 1, k2 = 2, k3 = t2 }
    local t3 = { k1 = 1, k2 = 2, k3 = { k1 = 1, k2 = 2, k3 = t2 } }
    t1.k3 = t1
    t2.k3 = t2

    assert.same(t1, t2)
    assert.same(t1, t3)
    assert.same(t1, t3)
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

  it("Checks near() assertion handles tolerances", function()
    assert.is.error(function() assert.near(0) end)  -- minimum 3 arguments
    assert.is.error(function() assert.near(0, 0) end)  -- minimum 3 arguments
    assert.is.error(function() assert.near('a', 0, 0) end)  -- arg1 must be convertable to number
    assert.is.error(function() assert.near(0, 'a', 0) end)  -- arg2 must be convertable to number
    assert.is.error(function() assert.near(0, 0, 'a') end)  -- arg3 must be convertable to number
    assert.is.near(1.5, 2.0, 0.5)
    assert.is.near('1.5', '2.0', '0.5')
    assert.is_not.near(1.5, 2.0, 0.499)
    assert.is_not.near('1.5', '2.0', '0.499')
  end)

  it("Checks matches() assertion does string matching", function()
    assert.is.error(function() assert.matches('.*') end)  -- minimum 2 arguments
    assert.is.error(function() assert.matches(nil, 's') end)  -- arg1 must be a string
    assert.is.error(function() assert.matches('s', {}) end)  -- arg2 must be convertable to string
    assert.is.error(function() assert.matches('s', 's', 's', 's') end)  -- arg3 or arg4 must be a number or nil
    assert.matches("%w+", "test")
    assert.has.match("%w+", "test")
    assert.has_no.match("%d+", "derp")
    assert.has.match("test", "test", nil, true)
    assert.has_no.match("%w+", "test", nil, true)
    assert.has.match("^test", "123 test", 5)
    assert.has_no.match("%d+", "123 test", '4')
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

  it("Checks '.' chaining of modifiers and assertions", function()
    assert.is.string("abc")
    assert.is.True(true)
    assert.is.Not.string(123)
    assert.is.Nil(nil)
    assert.is.Not.Nil({})
    assert.is.Not.True(false)
    assert.is.Not.False(true)
    assert.equals.Not(true, false)
    assert.equals.Not.Not(true, true)
    assert.Not.equals.Not(true, true)

    -- verify that failing assertions actually fail
    assert.has.error(function() assert.is.string(1) end)
    assert.has.error(function() assert.is.True(false) end)
    assert.has.error(function() assert.is.Not.string('string!') end)
    assert.has.error(function() assert.is.Nil({}) end)
    assert.has.error(function() assert.is.Not.Nil(nil) end)
    assert.has.error(function() assert.is.Not.True(true) end)
    assert.has.error(function() assert.is.Not.False(false) end)
    assert.has.error(function() assert.equals.Not(true, true) end)
    assert.has.error(function() assert.equals.Not.Not(true, false) end)
    assert.has.error(function() assert.Not.equals.Not(true, false) end)
  end)

  it("Checks number of returned arguments", function()
    local fn = function()
    end

    local fn1 = function()
      return "something",2,3
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

  it("Checks has_error to accept only callable arguments", function()
    local t_ok = setmetatable( {}, { __call = function() end } )
    local t_nok = setmetatable( {}, { __call = function() error("some error") end } )
    local f_ok = function() end
    local f_nok = function() error("some error") end
    
    assert.has_error(f_nok)
    assert.has_no_error(f_ok)
    assert.has_error(t_nok)
    assert.has_no_error(t_ok)
  end)

  it("Checks has_error compares error strings", function()
    assert.has_error(function() error() end)
    assert.has_error(function() error("string") end, "string")
  end)

  it("Checks has_error compares error objects", function()
    local func = function() end
    assert.has_error(function() error({ "table" }) end, { "table" })
    assert.has_error(function() error(func) end, func)
    assert.has_error(function() error(false) end, false)
    assert.has_error(function() error(true) end, true)
    assert.has_error(function() error(0) end, 0)
    assert.has_error(function() error(1.5) end, 1.5)
    assert.has_error(function() error(10.0^50) end, 10.0^50)
    assert.has_error(function() error(10.0^-50) end, 10.0^-50)
    assert.has_no_error(function() error(true) end, 0)
    assert.has_no_error(function() error(125) end, 1.5)
  end)

  it("Checks has_error compares error objects with strings", function()
    local mt = { __tostring = function(t) return t[1] end }
    assert.has_error(function() error(setmetatable({ "table" }, mt)) end, "table")
  end)

  it("Checks register creates custom assertions", function()
    local say = require("say")

    local function has_property(state, arguments)
      local property = arguments[1]
      local table = arguments[2]
      for key, value in pairs(table) do
        if key == property then
          return true
        end
      end
      return false
    end

    say:set_namespace("en")
    say:set("assertion.has_property.positive", "Expected property %s in:\n%s")
    say:set("assertion.has_property.negative", "Expected property %s to not be in:\n%s")
    assert:register("assertion", "has_property", has_property, "assertion.has_property.positive", "assertion.has_property.negative")

    assert.has_property("name", { name = "jack" })
    assert.has.property("name", { name = "jack" })
    assert.not_has_property("surname", { name = "jack" })
    assert.Not.has.property("surname", { name = "jack" })
    assert.has_error(function() assert.has_property("surname", { name = "jack" }) end)
    assert.has_error(function() assert.has.property("surname", { name = "jack" }) end)
    assert.has_error(function() assert.no_has_property("name", { name = "jack" }) end)
    assert.has_error(function() assert.no.has.property("name", { name = "jack" }) end)
  end)

  it("Checks unregister removes assertions", function()
    assert.has_no_error(function() assert.has_property("name", { name = "jack" }) end)

    assert:unregister("assertion", "has_property")

    assert.has_error(function() assert.has_property("name", { name = "jack" }) end, "luassert: unknown modifier/assertion: 'has_property'")
  end)

end)
