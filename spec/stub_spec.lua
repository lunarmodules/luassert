local match = require 'luassert.match'

describe("Tests dealing with stubs", function()
  local test = {}

  before_each(function()
    test = {key = function()
      return "derp"
    end}
  end)
  
  it("checks to see if stub keeps track of arguments", function()
    stub(test, "key")
    test.key("derp")
    assert.stub(test.key).was.called_with("derp")
    assert.error_matches(
      function() assert.stub(test.key).was.called_with("herp") end,
      "Function was never called with matching arguments.\n"
      .. "Called with (last call if any):\n"
        .. "(values list) ((string) 'derp')\n"
        .. "Expected:\n"
        .. "(values list) ((string) 'herp')",
      1, true)
  end)

  it("checks to see if stub keeps track of number of calls", function()
     stub(test, "key")
     test.key()
     test.key("test")
     assert.stub(test.key).was.called(2)
  end)

  it("checks called() and called_with() assertions", function()
    local s = stub.new(test, "key")

    s(1, 2, 3)
    s("a", "b", "c")
    assert.stub(s).was.called()
    assert.stub(s).was.called(2) -- twice!
    assert.stub(s).was_not.called(3)
    assert.stub(s).was_not.called_with({1, 2, 3}) -- mind the accolades
    assert.stub(s).was.called_with(1, 2, 3)
    assert.error_matches(
      function() assert.stub(s).was.called_with(5, 6) end,
      "Function was never called with matching arguments.\n"
      .. "Called with (last call if any):\n"
        .. "(values list) ((string) 'a', (string) 'b', (string) 'c')\n"
        .. "Expected:\n"
        .. "(values list) ((number) 5, (number) 6)",
      1, true)
  end)

  it("checks stub to fail when spying on non-callable elements", function()
    local s
    local testfunc = function()
      local t = { key = s}
      stub.new(t, "key")
    end
    -- try some types to fail
    s = "some string";  assert.has_error(testfunc)
    s = 10;             assert.has_error(testfunc)
    s = true;           assert.has_error(testfunc)
    -- try some types to succeed
    s = function() end; assert.has_no_error(testfunc)
    s = setmetatable( {}, { __call = function() end } ); assert.has_no_error(testfunc)
  end)

  it("checks reverting a stub call", function()
     local calls = 0
     local old = function() calls = calls + 1 end
     test.key = old
     local s = stub.new(test, "key")
     assert.is_table(s)
     s()
     s()
     assert.stub(s).was.called(2)  
     assert.are.equal(calls, 0)   -- its a stub, so no calls
     local old_s = s
     s = s:revert()
     s()
     assert.stub(old_s).was.called(2)  -- still two, stub was removed
     assert.are.equal(s, old)
     assert.are.equal(calls, 1)     -- restored, so now 1 call
  end)

  it("checks reverting a stub call on a nil value", function()
     test = {}
     local s = stub.new(test, "key")
     assert.is_table(s)
     s()
     s()
     assert.stub(s).was.called(2)  
     local old_s = s
     s = s:revert()
     assert.is_nil(s)
  end)

  it("checks creating and reverting a 'blank' stub", function()
     local s = stub.new()   -- use no parameters to create a blank
     assert.is_table(s)
     s()
     s()
     assert.stub(s).was.called(2)  
     local old_s = s
     s = s:revert()
     assert.is_nil(s)
  end)

  it("checks clearing a stub only clears call history", function()
     local s = stub.new(test, "key")
     s.returns("value")
     s.on_call_with("foo").returns("bar")
     s()
     s("foo")
     s:clear()
     assert.stub(s).was_not.called()
     assert.stub(s).was_not.returned_with("value")
     assert.stub(s).was_not.returned_with("bar")
     s("foo")
     assert.stub(s).was.returned_with("bar")
  end)

  it("returns nil by default", function()
    stub(test, "key")

    assert.is_nil(test.key())
  end)

  it("returns a given return value", function()
    stub(test, "key", "foo")

    assert.is.equal("foo", test.key())
  end)

  it("returns multiple given values", function()
    stub(test, "key", "foo", nil, "bar")

    local arg1, arg2, arg3 = test.key()

    assert.is.equal("foo", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
  end)

  it("calls specified stub function", function()
    stub(test, "key", function(a, b, c)
      return c, b, a
    end)

    local arg1, arg2, arg3 = test.key("bar", nil, "foo")

    assert.is.equal("foo", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
  end)

  it("calls specified stub callable object", function()
    local callable = setmetatable({}, { __call = function(self, a, b, c)
      return c, b, a
    end})
    stub(test, "key", callable)

    local arg1, arg2, arg3 = test.key("bar", nil, "foo")

    assert.is.equal("foo", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
  end)

  it("returning multiple given values overrides stub function", function()
    local function foo() end
    stub(test, "key", foo, nil, "bar")

    local arg1, arg2, arg3 = test.key()

    assert.is.equal(foo, arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
  end)

  it("returns default stub arguments", function()
    stub(test, "key").returns(nil, "foo", "bar")

    local arg1, arg2, arg3 = test.key("bar", nil, "foo")

    assert.is.equal(nil, arg1)
    assert.is.equal("foo", arg2)
    assert.is.equal("bar", arg3)
  end)

  it("invokes default stub function", function()
    stub(test, "key").invokes(function(a, b, c)
      return c, b, a
    end)

    local arg1, arg2, arg3 = test.key("bar", nil, "foo")

    assert.is.equal("foo", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
  end)

  it("returns stub arguments by default", function()
    stub(test, "key").by_default.returns("foo", "bar")

    local arg1, arg2 = test.key()

    assert.is.equal("foo", arg1)
    assert.is.equal("bar", arg2)
  end)

  it("invokes stub function by default", function()
    stub(test, "key").by_default.invokes(function(a, b)
      return b, a
    end)

    local arg1, arg2 = test.key("bar", "foo")

    assert.is.equal("foo", arg1)
    assert.is.equal("bar", arg2)
  end)

  it("on_call_with returns specified arguments", function()
    stub(test, "key").returns("foo bar")
    test.key.on_call_with("bar").returns("foo", nil, "bar")
    test.key.on_call_with(match._, "foo").returns("foofoo")

    local arg1, arg2, arg3 = test.key("bar")
    local foofoo1 = test.key(1, "foo")
    local foofoo2 = test.key(2, "foo")
    local foofoo3 = test.key(nil, "foo")
    local foobar = test.key()

    assert.is.equal("foo", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
    assert.is.equal("foo bar", foobar)
    assert.is.equal("foofoo", foofoo1)
    assert.is.equal("foofoo", foofoo2)
    assert.is.equal("foofoo", foofoo3)
  end)

  it("on_call_with invokes stub function", function()
    stub(test, "key").returns("foo foo")
    test.key.on_call_with("foo").invokes(function(a, b, c)
      return "bar", nil, "bar"
    end)

    local arg1, arg2, arg3 = test.key("foo")
    local foo = test.key()

    assert.is.equal("bar", arg1)
    assert.is.equal(nil, arg2)
    assert.is.equal("bar", arg3)
    assert.is.equal("foo foo", foo)
  end)

  it("on_call_with matches arguments for returns", function()
    local t = { foo = { bar = { "test" } } }
    stub(test, "key").returns("foo foo")
    test.key.on_call_with(t).returns("bar")
    t.foo.bar = "value"

    local bar = test.key({ foo = { bar = { "test" } } })
    local foofoo = test.key(t)

    assert.is.equal("bar", bar)
    assert.is.equal("foo foo", foofoo)
  end)

  it("on_call_with matches arguments for invokes", function()
    local t = { foo = { bar = { "test" } } }
    stub(test, "key").returns("foo foo")
    test.key.on_call_with(t).invokes(function() return "bar bar" end)
    t.foo.bar = "value"

    local bar = test.key({ foo = { bar = { "test" } } })
    local foofoo = test.key(t)

    assert.is.equal("bar bar", bar)
    assert.is.equal("foo foo", foofoo)
  end)

  it("on_call_with matches arguments using refs", function()
    local t1 = { foo = { bar = { "test" } } }
    local t2 = { foo = { bar = { "test" } } }
    stub(test, "key").returns("foo foo")
    test.key.on_call_with(match.is_ref(t1)).returns("bar")
    t1.foo.bar = "value"
    t2.foo.bar = "value"

    local bar = test.key(t1)
    local foo = test.key(t2)
    local foofoo = test.key({ foo = { bar = { "test" } } })

    assert.is.equal("bar", bar)
    assert.is.equal("foo foo", foo)
    assert.is.equal("foo foo", foofoo)
  end)

end)
