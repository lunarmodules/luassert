local match = require 'luassert.match'

describe("Tests dealing with spies", function()
  local test = {}

  before_each(function()
    assert:set_parameter("TableFormatLevel", 3)
    test = {key = function()
      return "derp"
    end}
  end)

  it("checks if a spy actually executes the internal function", function()
    spy.on(test, "key")
    assert(test.key() == "derp")
  end)

  it("checks to see if spy keeps track of arguments", function()
    spy.on(test, "key")

    test.key("derp")
    assert.spy(test.key).was.called_with("derp")
    assert.errors(function() assert.spy(test.key).was.called_with("herp") end)
  end)

  it("checks to see if spy keeps track of returned arguments", function()
    spy.on(test, "key")

    test.key()
    assert.spy(test.key).was.returned_with("derp")
    assert.errors(function() assert.spy(test.key).was.returned_with("herp") end)
  end)

  it("checks to see if spy keeps track of number of calls", function()
    spy.on(test, "key")
    test.key()
    test.key("test")
    assert.spy(test.key).was.called(2)
  end)

  it("checks returned_with() assertions", function()
    local s = spy.new(function(...) return ... end)
    local t = { foo = { bar = { "test" } } }
    local _ = match._

    s(1, 2, 3)
    s("a", "b", "c")
    s(t)
    t.foo.bar = "value"

    assert.spy(s).was.returned_with(1, 2, 3)
    assert.spy(s).was_not.returned_with({1, 2, 3}) -- mind the accolades
    assert.spy(s).was.returned_with(_, 2, 3) -- matches don't care
    assert.spy(s).was.returned_with(_, _, _) -- matches multiple don't cares
    assert.spy(s).was_not.returned_with(_, _, _, _) -- does not match if too many args
    assert.spy(s).was.returned_with({ foo = { bar = { "test" } } }) -- matches original table
    assert.spy(s).was_not.returned_with(t) -- does not match modified table
    assert.error_matches(
      function() assert.spy(s).returned_with(5, 6) end,
      "Function never returned matching arguments.\n"
      .. "Returned %(last call if any%):\n"
      .. "%(values list%) %(%(table: 0x%x+%) {\n"
      .. "  %[foo%] = {\n"
      .. "    %[bar%] = {\n"
      .. "      %[1%] = 'test' } } }.\n"
      .. "Expected:\n"
      .. "%(values list%) %(%(number%) 5, %(number%) 6%)")
  end)

  it("checks called() and called_with() assertions", function()
    local s = spy.new(function() end)
    local t = { foo = { bar = { "test" } } }
    local _ = match._

    s(1, 2, 3)
    s("a", "b", "c")
    s(t)
    t.foo.bar = "value"

    assert.spy(s).was.called()
    assert.spy(s).was.called(3) -- 3 times!
    assert.spy(s).was_not.called(4)
    assert.spy(s).was_not.called_with({1, 2, 3}) -- mind the accolades
    assert.spy(s).was.called_with(1, 2, 3)
    assert.spy(s).was.called_with(_, 2, 3) -- matches don't care
    assert.spy(s).was.called_with(_, _, _) -- matches multiple don't cares
    assert.spy(s).was_not.called_with(_, _, _, _) -- does not match if too many args
    assert.spy(s).was.called_with({ foo = { bar = { "test" } } }) -- matches original table
    assert.spy(s).was_not.called_with(t) -- does not match modified table
    assert.error_matches(
      function() assert.spy(s).was.called_with(5, 6) end,
      "Function was never called with matching arguments.\n"
      .. "Called with %(last call if any%):\n"
      .. "%(values list%) %(%(table: 0x%x+%) {\n"
      .. "  %[foo%] = {\n"
      .. "    %[bar%] = {\n"
      .. "      %[1%] = 'test' } } }%)\n"
      .. "Expected:\n"
      .. "%(values list%) %(%(number%) 5, %(number%) 6%)")
  end)

  it("checks called() and called_with() assertions using refs", function()
    local s = spy.new(function() end)
    local t1 = { foo = { bar = { "test" } } }
    local t2 = { foo = { bar = { "test" } } }

    s(t1)
    t1.foo.bar = "value"

    assert.spy(s).was.called_with(t2)
    assert.spy(s).was_not.called_with(match.is_ref(t2))
    assert.spy(s).was.called_with(match.is_ref(t1))
  end)

  it("checks called_with(aspy) assertions", function()
    local s = spy.new(function() end)

    s(s)

    assert.spy(s).was.called_with(s)
  end)

  it("checks called_at_least() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.at_least(1)
    assert.spy(s).was.called.at_least(2)
    assert.spy(s).was_not.called.at_least(3)
    assert.error_matches(
      function() assert.spy(s).was.called.at_least() end,
      "attempt to compare nil with number")
  end)

  it("checks called_at_most() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.at_most(3)
    assert.spy(s).was.called.at_most(2)
    assert.spy(s).was_not.called.at_most(1)
    assert.error_matches(
      function() assert.spy(s).was.called.at_most() end,
      "attempt to compare number with nil")
  end)

  it("checks called_more_than() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.more_than(0)
    assert.spy(s).was.called.more_than(1)
    assert.spy(s).was_not.called.more_than(2)
    assert.error_matches(
      function() assert.spy(s).was.called.more_than() end,
      "attempt to compare nil with number")
  end)

  it("checks called_less_than() assertions", function()
    local s = spy.new(function() end)

    s(1, 2, 3)
    s("a", "b", "c")
    assert.spy(s).was.called.less_than(4)
    assert.spy(s).was.called.less_than(3)
    assert.spy(s).was_not.called.less_than(2)
    assert.error_matches(
      function() assert.spy(s).was.called.less_than() end,
      "attempt to compare number with nil")
  end)

  it("checks if called()/called_with assertions fail on non-spies ", function()
    assert.has_error(assert.was.called)
    assert.has_error(assert.was.called_at_least)
    assert.has_error(assert.was.called_at_most)
    assert.has_error(assert.was.called_more_than)
    assert.has_error(assert.was.called_less_than)
    assert.has_error(assert.was.called_with)
    assert.has_error(assert.was.returned_with)
  end)

  it("checks spies to fail when spying on non-callable elements", function()
    local s
    local testfunc = function()
      spy.new(s)
    end
    -- try some types to fail
    s = "some string";  assert.has_error(testfunc)
    s = 10;             assert.has_error(testfunc)
    s = true;           assert.has_error(testfunc)
    -- try some types to succeed
    s = function() end; assert.has_no_error(testfunc)
    s = setmetatable( {}, { __call = function() end } ); assert.has_no_error(testfunc)
  end)

  it("checks reverting a spy.on call", function()
     local old = test.key
     local s = spy.on(test, "key")
     test.key()
     test.key("test")
     assert.spy(test.key).was.called(2)
     -- revert and call again
     s:revert()
     assert.are.equal(old, test.key)
     test.key()
     test.key("test")
     assert.spy(s).was.called(2) -- still two, spy was removed
  end)

  it("checks reverting a spy.new call", function()
     local calls = 0
     local old = function() calls = calls + 1 end
     local s = spy.new(old)
     assert.is_table(s)
     s()
     s()
     assert.spy(s).was.called(2)
     assert.are.equal(calls, 2)
     local old_s = s
     s = s:revert()
     assert.are.equal(s, old)
     s()
     assert.spy(old_s).was.called(2)  -- still two, spy was removed
     assert.are.equal(calls, 3)
  end)

  it("checks clearing a spy.on call history", function()
     local s = spy.on(test, "key")
     test.key()
     test.key("test")
     s:clear()
     assert.spy(s).was.called(0)
  end)

  it("checks clearing a spy.new call history", function()
     local s = spy.new(function() return "foobar" end)
     s()
     s("test")
     s:clear()
     assert.spy(s).was.called(0)
     assert.spy(s).was_not.returned_with("foobar")
  end)

  it("checks spy.new can be constructed without arguments", function()
    local s = spy.new()
    s()
    assert.spy(s).was.called(1)
  end)

  it("reports some argumentslist the spy was called_with when none matches", function()
    local s = spy.new(function() end)
    s("herp", nil, "bust", nil)
    assert.error_matches(
      function() assert.spy(s).was.called_with() end,
      "Function was never called with matching arguments.\n"
      .. "Called with (last call if any):\n"
      .. "(values list) ((string) 'herp', (nil), (string) 'bust', (nil))\n"
      .. "Expected:\n"
      .. "(values list) ()",
      1, true)
  end)

  it("reports some matching call argumentslist when none should match", function()
    assert:set_parameter("TableFormatLevel", 4)
    local s = spy.new(function() end)
    s({}, nil, {}, nil)
    s("herp", nil, "bust", nil)
    s({}, nil, {}, nil)
    assert.error_matches(
      function()
        assert.spy(s).was_not.called_with(match.match("er"), nil, match.string(), nil)
      end,
      "Function was called with matching arguments at least once.\n"
      .. "Called with (last matching call):\n"
      .. "(values list) ((string) 'herp', (nil), (string) 'bust', (nil))\n"
      .. "Did not expect:\n"
      .. "(values list) ((matcher) is.match((string) 'er'), (nil), (matcher) is.string(), (nil))",
      1, true)
  end)

  it("makes legible errors when never called", function()
    local s = spy.new(function() end)
    assert.error_matches(
      function() assert.spy(s).was.called_with("derp", nil, "bust", nil) end,
      "Function was never called with matching arguments.\n"
      .. "Called with (last call if any):\n"
      .. "(nil)\n"
      .. "Expected:\n"
      .. "(values list) ((string) 'derp', (nil), (string) 'bust', (nil))",
      1, true)
  end)

  it("reports some return values from the spy when none mathes", function()
    local s = spy.new(function(...) return ... end)
    s("herp", nil, "bust", nil)
    assert.error_matches(
      function() assert.spy(s).returned_with("derp", nil, "bust", nil) end,
      "Function never returned matching arguments.\n"
      .. "Returned (last call if any):\n"
      .. "(values list) ((string) 'herp', (nil), (string) 'bust', (nil))\n"
      .. "Expected:\n"
      .. "(values list) ((string) 'derp', (nil), (string) 'bust', (nil))",
      1, true)
  end)

  it("reports some matching return values when none should match", function()
    assert:set_parameter("TableFormatLevel", 4)
    local s = spy.new(function(...) return ... end)
    s({}, nil, {}, nil)
    s("herp", nil, "bust", nil)
    s({}, nil, {}, nil)
    assert.error_matches(
      function()
        assert.spy(s).has_not.returned_with(match.matches("er"), nil, match.is_string(), nil)
      end,
      "Function returned matching arguments at least once.\n"
      .. "Returned (last matching call):\n"
      .. "(values list) ((string) 'herp', (nil), (string) 'bust', (nil))",
      1, true)
  end)

  it("makes legible errors when never returned", function()
    local s = spy.new(function(...) return ... end)
    assert.error_matches(
      function() assert.spy(s).returned_with() end,
      "Function never returned matching arguments.\n"
      .. "Returned (last call if any):\n"
      .. "(nil)\n"
      .. "Expected:\n"
      .. "(values list) ()",
      1, true)
  end)
end)
