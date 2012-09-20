Luassert
========

[![Build Status](https://secure.travis-ci.org/Olivine-Labs/luassert.png)](http://secure.travis-ci.org/Olivine-Labs/luassert)

luassert extends Lua's built-in assertions to provide additional tests and the
ability to create your own. You can modify chains of assertions with `not`.

Check out [busted](http://www.olivinelabs.com/busted#asserts) for
extended examples.

```lua
assert = require("luassert")

assert.true(true)
assert.is.true(true)
assert.is_not.true(false)
assert.are.equal(1, 1)
assert.has.errors(function() error("this should fail") end)
```
Extend your own:

```lua
local assert = require("luassert")
local say    = require("say") --our i18n lib, installed through luarocks, included as a luassert dependency

local function has_property(table, prop)
  for _, value in pairs(table) do
    if value == prop then
      return true
    end
  end
  return false, {prop, table}
end

say:set_namespace("en")
say:set("assertion.has_property.positive", "Expected property %s in:\n%s")
say:set("assertion.has_property.negative", "Expected property %s to not be in:\n%s")
assert:register("assertion", "has_property", has_property, "assertion.has_property.positive", "assertion.has_property.negative")

assert.has_property({ name = "jack" }, "name")
```
