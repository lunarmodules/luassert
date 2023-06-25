local match = require 'luassert.match'

assert(type(match) == "table")

describe("Test Matchers", function()
  it("Checks wildcard() matcher", function()
    assert.is_true(match._(nil))
    assert.is_true(match._(true))
    assert.is_true(match._(false))
    assert.is_true(match._(123))
    assert.is_true(match._(""))
    assert.is_true(match._({}))
    assert.is_true(match._(function() end))
  end)

  it("Checks truthy() matcher", function()
    assert.is_false(match.truthy()(nil))
    assert.is_true(match.truthy()(true))
    assert.is_false(match.truthy()(false))
    assert.is_true(match.truthy()(123))
    assert.is_true(match.truthy()(""))
    assert.is_true(match.truthy()({}))
    assert.is_true(match.truthy()(function() end))
  end)

  it("Checks falsy() matcher", function()
    assert.is_true(match.falsy()(nil))
    assert.is_false(match.falsy()(true))
    assert.is_true(match.falsy()(false))
    assert.is_false(match.falsy()(123))
    assert.is_false(match.falsy()(""))
    assert.is_false(match.falsy()({}))
    assert.is_false(match.falsy()(function() end))
  end)

  it("Checks true() matcher", function()
    assert.is_false(match.is_true()(nil))
    assert.is_true(match.is_true()(true))
    assert.is_false(match.is_true()(false))
    assert.is_false(match.is_true()(123))
    assert.is_false(match.is_true()(""))
    assert.is_false(match.is_true()({}))
    assert.is_false(match.is_true()(function() end))
  end)

  it("Checks false() matcher", function()
    assert.is_false(match.is_false()(nil))
    assert.is_false(match.is_false()(true))
    assert.is_true(match.is_false()(false))
    assert.is_false(match.is_false()(123))
    assert.is_false(match.is_false()(""))
    assert.is_false(match.is_false()({}))
    assert.is_false(match.is_false()(function() end))
  end)

  it("Checks nil() matcher", function()
    assert.is_true(match.is_nil()(nil))
    assert.is_false(match.is_nil()(true))
    assert.is_false(match.is_nil()(false))
    assert.is_false(match.is_nil()(123))
    assert.is_false(match.is_nil()(""))
    assert.is_false(match.is_nil()({}))
    assert.is_false(match.is_nil()(function() end))
  end)

  it("Checks boolean() matcher", function()
    assert.is_false(match.is_boolean()(nil))
    assert.is_true(match.is_boolean()(true))
    assert.is_true(match.is_boolean()(false))
    assert.is_false(match.is_boolean()(123))
    assert.is_false(match.is_boolean()(""))
    assert.is_false(match.is_boolean()({}))
    assert.is_false(match.is_boolean()(function() end))
  end)

  it("Checks number() matcher", function()
    assert.is_false(match.is_number()(nil))
    assert.is_false(match.is_number()(true))
    assert.is_false(match.is_number()(false))
    assert.is_true(match.is_number()(123))
    assert.is_false(match.is_number()(""))
    assert.is_false(match.is_number()({}))
    assert.is_false(match.is_number()(function() end))
  end)

  it("Checks string() matcher", function()
    assert.is_false(match.is_string()(nil))
    assert.is_false(match.is_string()(true))
    assert.is_false(match.is_string()(false))
    assert.is_false(match.is_string()(123))
    assert.is_true(match.is_string()(""))
    assert.is_false(match.is_string()({}))
    assert.is_false(match.is_string()(function() end))
  end)

  it("Checks table() matcher", function()
    assert.is_false(match.is_boolean()(nil))
    assert.is_false(match.is_table()(nil))
    assert.is_false(match.is_table()(true))
    assert.is_false(match.is_table()(false))
    assert.is_false(match.is_table()(123))
    assert.is_false(match.is_table()(""))
    assert.is_true(match.is_table()({}))
    assert.is_false(match.is_table()(function() end))
  end)

  it("Checks function() matcher", function()
    assert.is_false(match.is_function()(nil))
    assert.is_false(match.is_function()(true))
    assert.is_false(match.is_function()(false))
    assert.is_false(match.is_function()(123))
    assert.is_false(match.is_function()(""))
    assert.is_false(match.is_function()({}))
    assert.is_true(match.is_function()(function() end))
  end)

  it("Checks userdata() matcher", function()
    assert.is_true(match.is_userdata()(io.stdout))
    assert.is_false(match.is_userdata()(nil))
    assert.is_false(match.is_userdata()(true))
    assert.is_false(match.is_userdata()(false))
    assert.is_false(match.is_userdata()(123))
    assert.is_false(match.is_userdata()(""))
    assert.is_false(match.is_userdata()({}))
    assert.is_false(match.is_userdata()(function() end))
  end)

  it("Checks thread() matcher", function()
    local mythread = coroutine.create(function() end)
    assert.is_true(match.is_thread()(mythread))
    assert.is_false(match.is_thread()(nil))
    assert.is_false(match.is_thread()(true))
    assert.is_false(match.is_thread()(false))
    assert.is_false(match.is_thread()(123))
    assert.is_false(match.is_thread()(""))
    assert.is_false(match.is_thread()({}))
    assert.is_false(match.is_thread()(function() end))
  end)

  it("Checks to see if tables 1 and 2 are equal", function()
    local table1 = { derp = false}
    local table2 = table1
    assert.is_true(match.is_equal(table1)(table2))
    assert.is_true(match.is_equal(table2)(table1))
  end)

  it("Checks equals() matcher to handle nils properly", function()
    assert.is.error(function() match.is_equals() end)  -- minimum 1 argument
    assert.is_true(match.is_equal(nil)(nil))
    assert.is_false(match.is_equal("a string")(nil))
    assert.is_false(match.is_equal(nil)("a string"))
  end)

  it("Checks the same() matcher for tables with protected metatables", function()
    local troubleSomeTable = {}
    setmetatable(troubleSomeTable, {__metatable = 0})
    assert.is_true(match.is_same(troubleSomeTable)(troubleSomeTable))
  end)

  it("Checks same() matcher to handle nils properly", function()
    assert.is.error(function() match.same()() end)  -- minimum 1 arguments
    assert.is_true(match.is_same(nil)(nil))
    assert.is_false(match.is_same("a string")(nil))
    assert.is_false(match.is_same(nil)("a string"))
  end)

  it("Checks same() matcher to handle table keys properly", function()
    assert.is_true(match.is_same({ [{}] = 1 })({ [{}] = 1}))
  end)

  it("Checks ref() matcher", function()
    local t = {}
    local func = function() end
    local mythread = coroutine.create(func)
    assert.is.error(function() match.is_ref() end)      -- minimum 1 arguments
    assert.is.error(function() match.is_ref(0) end)     -- arg1 must be an object
    assert.is.error(function() match.is_ref('') end)    -- arg1 must be an object
    assert.is.error(function() match.is_ref(nil) end)   -- arg1 must be an object
    assert.is.error(function() match.is_ref(true) end)  -- arg1 must be an object
    assert.is.error(function() match.is_ref(false) end) -- arg1 must be an object
    assert.is_true(match.is_ref(t)(t))
    assert.is_true(match.is_ref(func)(func))
    assert.is_true(match.is_ref(mythread)(mythread))
    assert.is_false(match.is_ref(t)(func))
    assert.is_false(match.is_ref(t)(mythread))
    assert.is_false(match.is_ref(t)(nil))
    assert.is_false(match.is_ref(t)(true))
    assert.is_false(match.is_ref(t)(false))
    assert.is_false(match.is_ref(t)(123))
    assert.is_false(match.is_ref(t)(""))
    assert.is_false(match.is_ref(t)({}))
    assert.is_false(match.is_ref(t)(function() end))
  end)

  it("Checks matches() matcher does string matching", function()
    assert.is.error(function() match.matches() end)  -- minimum 1 arguments
    assert.is.error(function() match.matches({}) end)  -- arg1 must be a string
    assert.is.error(function() match.matches('s', 's') end)  -- arg2 must be a number or nil
    assert.is_true(match.matches("%w+")("test"))
    assert.is_true(match.has.match("%w+")("test"))
    assert.is_false(match.matches("%d+")("derp"))
    assert.is_true(match.has_match("test", nil, true)("test"))
    assert.is_false(match.has_match("%w+", nil, true)("test"))
    assert.is_true(match.has_match("^test", 5)("123 test"))
    assert.is_false(match.has_match("%d+", '4')("123 test"))
  end)

  it("Checks near() matcher handles tolerances", function()
    assert.is.error(function() match.near(0) end)  -- minimum 2 arguments
    assert.is.error(function() match.near('a', 0) end)  -- arg1 must be convertable to number
    assert.is.error(function() match.near(0, 'a') end)  -- arg2 must be convertable to number
    assert.is_true(match.is.near(1.5, 0.5)(2.0))
    assert.is_true(match.is.near('1.5', '0.5')('2.0'))
    assert.is_true(match.is_not.near(1.5, 0.499)(2.0))
    assert.is_true(match.is_not.near('1.5', '0.499')('2.0'))
  end)

  it("Checks to see if table1 only contains unique elements", function()
    local table2 = { derp = false}
    local table3 = { derp = true }
    local table1 = {table2,table3}
    local tablenotunique = {table2,table2}
    assert.is_true(match.is.unique()(table1))
    assert.is_true(match.is_not.unique()(tablenotunique))
  end)

  it("Checks to see if table1 only contains unique elements, including table keys", function()
    assert.is_true(match.is_not.unique(true)({ [{}] = 1, [{}] = 1 }, true))
    assert.is_true(match.is_not.unique(true)({{ [{}] = 1 }, { [{}] = 1 }}, true))
  end)

  it("Checks '_' chaining of modifiers and match", function()
    assert.is_true(match.is_string()("abc"))
    assert.is_true(match.is_true()(true))
    assert.is_true(match.is_not_string()(123))
    assert.is_true(match.is_nil()(nil))
    assert.is_true(match.is_not_nil()({}))
    assert.is_true(match.is_not_true()(false))
    assert.is_true(match.is_not_false()(true))

    -- verify that failing match return false
    assert.is_false(match.is_string()(1))
    assert.is_false(match.is_true()(false))
    assert.is_false(match.is_not_string()('string!'))
    assert.is_false(match.is_nil()({}))
    assert.is_false(match.is_not_nil()(nil))
    assert.is_false(match.is_not_true()(true))
    assert.is_false(match.is_not_false()(false))
  end)

  it("Checks '.' chaining of modifiers and match", function()
    assert.is_true(match.is.string()("abc"))
    assert.is_true(match.is.True()(true))
    assert.is_true(match.is.Not.string()(123))
    assert.is_true(match.is.Nil()(nil))
    assert.is_true(match.is.Not.Nil()({}))
    assert.is_true(match.is.Not.True()(false))
    assert.is_true(match.is.Not.False()(true))
    assert.is_true(match.equals.Not(true)(false))
    assert.is_true(match.equals.Not.Not(true)(true))
    assert.is_true(match.Not.equals.Not(true)(true))

    -- verify that failing match return false
    assert.is_false(match.is.string()(1))
    assert.is_false(match.is.True()(false))
    assert.is_false(match.is.Not.string()('string!'))
    assert.is_false(match.is.Nil()({}))
    assert.is_false(match.is.Not.Nil()(nil))
    assert.is_false(match.is.Not.True()(true))
    assert.is_false(match.is.Not.False()(false))
    assert.is_false(match.equals.Not(true)(true))
    assert.is_false(match.equals.Not.Not(true)(false))
    assert.is_false(match.Not.equals.Not(true)(false))
  end)

  it("Checks called_with() argument matching for spies", function()
    local s = spy.new(function() return "foo" end)
    s(1)
    s(nil, "")
    s({}, "")
    s(function() end, "")
    s(1, 2, 3)
    s("a", "b", "c", "d")
    assert.spy(s).was.called_with(match._)
    assert.spy(s).was.called_with(match.is_number())
    assert.spy(s).was.called_with(match.is_number(), match.is_number(), match.is_number())
    assert.spy(s).was_not.called_with(match.is_string())
    assert.spy(s).was.called_with(match.is_string(), match.is_string(), match.is_string(), match.is_string())
    assert.spy(s).was.called_with(match.is_nil(), match._)
    assert.spy(s).was.called_with(match.is_table(), match._)
    assert.spy(s).was.called_with(match.is_function(), match._)
    assert.spy(s).was_not.called_with(match.is_nil())
    assert.spy(s).was_not.called_with(match.is_table())
    assert.spy(s).was_not.called_with(match.is_function())
  end)

  it("Checks returned_with() argument matching for spies", function()
    local s = spy.new(function() return "foo" end)
    s()
    assert.spy(s).was.returned_with(match._)
    assert.spy(s).was.returned_with(match.is_string())
    assert.spy(s).was.returned_with(match.is_not_number())
    assert.spy(s).was.returned_with(match.is_not_table())
    assert.spy(s).was_not.returned_with(match.is_number())
    assert.spy(s).was_not.returned_with(match.is_table())
  end)

  it("Checks on_call_with() argument matching for stubs", function()
    local test = {}
    local s = stub(test, "key").returns("foo")
    s.on_call_with(match.is_string()).returns("bar")
    s.on_call_with(match.is_number()).returns(555)
    s.on_call_with(match.is_table()).returns({"foo"})
    s(0)
    s("")
    s({})
    assert.spy(s).was.returned_with(555)
    assert.spy(s).was.returned_with("bar")
    assert.spy(s).was.returned_with({"foo"})
  end)

  it("Checks returned_with() argument matching for spies", function()
    local s = spy.new(function() return "foo" end)
    s()
    assert.spy(s).was.returned_with(match._)
    assert.spy(s).was.returned_with(match.is_string())
    assert.spy(s).was.returned_with(match.is_not_nil())
    assert.spy(s).was.returned_with(match.is_not_number())
    assert.spy(s).was.returned_with(match.is_not_table())
    assert.spy(s).was.returned_with(match.is_not_function())
  end)

  it("Checks none() composite matcher", function()
    assert.has.error(function() match.none_of() end)  -- minimum 1 arguments
    assert.has.error(function() match.none_of('') end)  -- arg must be a matcher
    assert.has.error(function() match.none_of('', 0) end)  -- all args must be a match

    assert.is_false(match.none_of(match.is_string())(''))
    assert.is_true(match.none_of(match.is_number())(''))
    assert.is_true(match.none_of(match.is_number(), match.is_function())(''))
    assert.is_false(match.none_of(match.is_number(), match.is_not_function())(''))
    assert.is_false(match.not_none_of(match.is_number(), match.is_function())(''))
  end)

  it("Checks any() composite matcher", function()
    assert.has.error(function() match.any_of() end)  -- minimum 1 arguments
    assert.has.error(function() match.any_of('') end)  -- arg must be a matcher
    assert.has.error(function() match.any_of('', 0) end)  -- all args must be a match

    assert.is_true(match.any_of(match.is_string())(''))
    assert.is_false(match.any_of(match.is_number())(''))
    assert.is_false(match.any_of(match.is_number(), match.is_function())(''))
    assert.is_true(match.any_of(match.is_number(), match.is_not_function())(''))
    assert.is_true(match.not_any_of(match.is_number(), match.is_function())(''))
  end)

  it("Checks all() composite matcher", function()
    assert.has.error(function() match.all_of() end)  -- minimum 1 arguments
    assert.has.error(function() match.all_of('') end)  -- arg must be a matcher
    assert.has.error(function() match.all_of('', 0) end)  -- all args must be a match

    assert.is_true(match.all_of(match.is_string())(''))
    assert.is_false(match.all_of(match.is_number())(''))
    assert.is_false(match.all_of(match.is_number(), match.is_function())(''))
    assert.is_false(match.all_of(match.is_number(), match.is_not_function())(''))
    assert.is_true(match.not_all_of(match.is_number(), match.is_function())(''))
    assert.is_true(match.all_of(match.is_not_number(), match.is_not_function())(''))
  end)

end)
