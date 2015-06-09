local unpack = require 'luassert.compatibility'.unpack

describe("Output testing using string comparison with the equal assertion", function()
  local getoutput = function(...)
    local success, message = pcall(assert.are.equal, ...)
    if message == nil then return nil end
    return tostring(message)
  end

  it("Should compare strings correctly; nil-string", function()
    --assert.are.equal(nil, "string")
    local output = getoutput(nil, "string")
    local ok = output:find("Passed in:\n%(string%) 'string'")
    assert(ok, "Output check 1 failed, comparing nil-string;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(nil%)")
    assert(ok, "Output check 2 failed, comparing nil-string;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare strings correctly; string-nil", function()
    --assert.are.equal("string", nil)
    local output = getoutput("string", nil)
    local ok = output:find("Passed in:\n%(nil%)")
    assert(ok, "Output check 1 failed, comparing string-nil;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(string%) 'string'")
    assert(ok, "Output check 2 failed, comparing string-nil;\n    " .. output:gsub("\n","\n    "))
  end)

end)

describe("Output testing using string comparison with the has_error assertion", function()
  local getoutput = function(...)
    local success, message = pcall(assert.has_error, ...)
    if message == nil then return nil end
    return tostring(message)
  end

  it("Should report no error caught, but error expected; noerror-nil", function()
    --assert.has_error(function() end)
    local output = getoutput(function() end)
    local ok = output:find("Caught:\n%(no error%)")
    assert(ok, "Output check 1 failed, comparing noerror-nil;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(error%)")
    assert(ok, "Output check 2 failed, comparing noerror-nil;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should report no error caught, but error string expected; noerror-string", function()
    --assert.has_error(function() end, "string")
    local output = getoutput(function() end, 'string')
    local ok = output:find("Caught:\n%(no error%)")
    assert(ok, "Output check 1 failed, comparing noerror-string;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(string%) 'string'")
    assert(ok, "Output check 2 failed, comparing noerror-string;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare error strings correctly; nil-string", function()
    --assert.has_error(function() error() end, "string")
    local output = getoutput(function() error() end, "string")
    local ok = output:find("Caught:\n%(nil%)")
    assert(ok, "Output check 1 failed, comparing nil-string;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(string%) 'string'")
    assert(ok, "Output check 2 failed, comparing nil-string;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare error strings correctly; string-string", function()
    --assert.has_error(function() error("string") end, "string_")
    local output = getoutput(function() error("string") end, "string_")
    local ok = output:find("Caught:\n%(string%) '.*string'")
    assert(ok, "Output check 1 failed, comparing string-string;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(string%) 'string_'")
    assert(ok, "Output check 2 failed, comparing string-string;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare error strings correctly; table-string", function()
    --assert.has_error(function() error({}) end, "string")
    local output = getoutput(function() error({}) end, "string")
    local ok = output:find("Caught:\n%(table%) { }")
    assert(ok, "Output check 1 failed, comparing table-string;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(string%) 'string'")
    assert(ok, "Output check 2 failed, comparing table-string;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare error strings correctly; string-table", function()
    --assert.has_error(function() error("string") end, {})
    local output = getoutput(function() error("string") end, {})
    local ok = output:find("Caught:\n%(string%) 'string'")
    assert(ok, "Output check 1 failed, comparing string-table;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(table%) { }")
    assert(ok, "Output check 2 failed, comparing string-table;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare error objects correctly; table-table", function()
    --assert.has_error(function() error({}) end, { "table" })
    local output = getoutput(function() error({}) end, { "table" })
    local ok = output:find("Caught:\n%(table%) { }")
    assert(ok, "Output check 1 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n%(table%) {\n  %[1] = 'table' }")
    assert(ok, "Output check 2 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
  end)

end)

describe("Output testing using string comparison with the same assertion", function()
  local getoutput = function(...)
    local success, message = pcall(assert.are.same, ...)
    if message == nil then return nil end
    return tostring(message)
  end

  it("Should compare tables correctly", function()
    -- assert.are.same({1}, {2})
    local output = getoutput({1}, {2})
    local ok = output:find("Passed in:\n(table) {\n *[1] = 2 }", nil, true)
    assert(ok, "Output check 1 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n(table) {\n *[1] = 1 }", nil, true)
    assert(ok, "Output check 2 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
  end)

  it("Should compare tables correctly and highlight differences", function()
    -- assert.are.same(t1, t2)
    local t1 = {1, {"a", "b", {"foo", "bar"} }, "c"}
    local t2 = {1, {"a", "b", {"bar", "bar"} }, "c"}
    local output = getoutput(t1, t2)
    local ok = output:find("Passed in:\n.*%*%[2].*%*%[3].*%*%[1] = 'bar'\n")
    assert(ok, "Output check 1 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
    local ok = output:find("Expected:\n.*%*%[2].*%*%[3].*%*%[1] = 'foo'\n")
    assert(ok, "Output check 2 failed, comparing table-table;\n    " .. output:gsub("\n","\n    "))
  end)

end)

describe("Output testing using custom failure message", function()
  local geterror = function(key, ...)
    local argcnt = select("#", ...)
    local args = {...}
    args[argcnt+1] = key .. " fails"
    local success, message = pcall(assert[key], unpack(args, 1, argcnt+1))
    if message == nil then return nil end
    message = tostring(message):gsub("\n.*", ""):gsub("^.-:%d+: ", "", 1)
    return message
  end

  local geterror2 = function(key, ...)
    local success, message = pcall(assert.message(key .. " fails")[key], ...)
    if message == nil then return nil end
    message = tostring(message):gsub("\n.*", ""):gsub("^.-:%d+: ", "", 1)
    return message
  end

  it("Should use failure message for is_true assertion", function()
    assert.is_equal("is_true fails", geterror("is_true", false))
    assert.is_equal("is_true fails", geterror2("is_true", false))
    assert.is_equal("is_not_true fails", geterror("is_not_true", true))
    assert.is_equal("is_not_true fails", geterror2("is_not_true", true))
  end)

  it("Should use failure message for is_false assertion", function()
    assert.is_equal("is_false fails", geterror("is_false", true))
    assert.is_equal("is_false fails", geterror2("is_false", true))
    assert.is_equal("is_not_false fails", geterror("is_not_false", false))
    assert.is_equal("is_not_false fails", geterror2("is_not_false", false))
  end)

  it("Should use failure message for is_truthy assertion", function()
    assert.is_equal("is_truthy fails", geterror("is_truthy", false))
    assert.is_equal("is_truthy fails", geterror2("is_truthy", false))
    assert.is_equal("is_not_truthy fails", geterror("is_not_truthy", true))
    assert.is_equal("is_not_truthy fails", geterror2("is_not_truthy", true))
  end)

  it("Should use failure message for is_falsy assertion", function()
    assert.is_equal("is_falsy fails", geterror("is_falsy", true))
    assert.is_equal("is_falsy fails", geterror2("is_falsy", true))
    assert.is_equal("is_not_falsy fails", geterror("is_not_falsy", false))
    assert.is_equal("is_not_falsy fails", geterror2("is_not_falsy", false))
  end)

  it("Should use failure message for is_type assertions", function()
    assert.is_equal("is_boolean fails", geterror("is_boolean", nil))
    assert.is_equal("is_number fails", geterror("is_number", nil))
    assert.is_equal("is_string fails", geterror("is_string", nil))
    assert.is_equal("is_table fails", geterror("is_table", nil))
    assert.is_equal("is_nil fails", geterror("is_nil", "nil"))
    assert.is_equal("is_userdata fails", geterror("is_userdata", nil))
    assert.is_equal("is_function fails", geterror("is_function", nil))
    assert.is_equal("is_thread fails", geterror("is_thread", nil))

    assert.is_equal("is_boolean fails", geterror2("is_boolean", nil))
    assert.is_equal("is_number fails", geterror2("is_number", nil))
    assert.is_equal("is_string fails", geterror2("is_string", nil))
    assert.is_equal("is_table fails", geterror2("is_table", nil))
    assert.is_equal("is_nil fails", geterror2("is_nil", "nil"))
    assert.is_equal("is_userdata fails", geterror2("is_userdata", nil))
    assert.is_equal("is_function fails", geterror2("is_function", nil))
    assert.is_equal("is_thread fails", geterror2("is_thread", nil))

    local thread = coroutine.create(function() end)
    assert.is_equal("is_not_boolean fails", geterror("is_not_boolean", true))
    assert.is_equal("is_not_number fails", geterror("is_not_number", 0))
    assert.is_equal("is_not_string fails", geterror("is_not_string", ''))
    assert.is_equal("is_not_table fails", geterror("is_not_table", {}))
    assert.is_equal("is_not_nil fails", geterror("is_not_nil", nil))
    assert.is_equal("is_not_userdata fails", geterror("is_not_userdata", io.stdin))
    assert.is_equal("is_not_function fails", geterror("is_not_function", function()end))
    assert.is_equal("is_not_thread fails", geterror("is_not_thread", thread))

    assert.is_equal("is_not_boolean fails", geterror2("is_not_boolean", true))
    assert.is_equal("is_not_number fails", geterror2("is_not_number", 0))
    assert.is_equal("is_not_string fails", geterror2("is_not_string", ''))
    assert.is_equal("is_not_table fails", geterror2("is_not_table", {}))
    assert.is_equal("is_not_nil fails", geterror2("is_not_nil", nil))
    assert.is_equal("is_not_userdata fails", geterror2("is_not_userdata", io.stdin))
    assert.is_equal("is_not_function fails", geterror2("is_not_function", function()end))
    assert.is_equal("is_not_thread fails", geterror2("is_not_thread", thread))
  end)

  it("Should use failure message for is_equal assertion", function()
    assert.is_equal("equals fails", geterror("equals", true, false))
    assert.is_equal("equals fails", geterror2("equals", true, false))
    assert.is_equal("not_equals fails", geterror("not_equals", true, true))
    assert.is_equal("not_equals fails", geterror2("not_equals", true, true))
  end)

  it("Should use failure message for is_same assertion", function()
    assert.is_equal("same fails", geterror("same", true, false))
    assert.is_equal("same fails", geterror2("same", true, false))
    assert.is_equal("not_same fails", geterror("not_same", true, true))
    assert.is_equal("not_same fails", geterror2("not_same", true, true))
  end)

  it("Should use failure message for is_same assertion: table-table", function()
    assert.is_equal("same fails", geterror("same", {}, {1}))
    assert.is_equal("same fails", geterror2("same", {}, {1}))
    assert.is_equal("not_same fails", geterror("not_same", {}, {}))
    assert.is_equal("not_same fails", geterror2("not_same", {}, {}))
  end)

  it("Should use failure message for is_unique assertion: shallow compare", function()
    assert.is_equal("unique fails", geterror("unique", {1, 1}))
    assert.is_equal("unique fails", geterror2("unique", {1, 1}))
    assert.is_equal("not_unique fails", geterror("not_unique", {1, 0}))
    assert.is_equal("not_unique fails", geterror2("not_unique", {1, 0}))
  end)

  it("Should use failure message for is_unique assertion: nil deep compare", function()
    assert.is_equal("unique fails", geterror("unique", {1, 1}, nil))
    assert.is_equal("unique fails", geterror2("unique", {1, 1}, nil))
    assert.is_equal("not_unique fails", geterror("not_unique", {1, 0}, nil))
    assert.is_equal("not_unique fails", geterror2("not_unique", {1, 0}, nil))
  end)

  it("Should use failure message for is_unique assertion: deep compare", function()
    assert.is_equal("unique fails", geterror("unique", {{1}, {1}}, true))
    assert.is_equal("unique fails", geterror2("unique", {{1}, {1}}, true))
    assert.is_equal("not_unique fails", geterror("not_unique", {{0}, {1}}, true))
    assert.is_equal("not_unique fails", geterror2("not_unique", {{0}, {1}}, true))
  end)

  it("Should use failure message for is_unique assertion: deep compare 2", function()
    local err1 = geterror("unique", {{1}, {1}}, "unique deep compare 2 fails", true)
    local err2 = geterror("not_unique", {{0}, {1}}, "not unique deep compare 2 fails", true)
    assert.is_equal("unique deep compare 2 fails", err1)
    assert.is_equal("not unique deep compare 2 fails", err2)
  end)

  it("Should use failure message for is_near assertion", function()
    assert.is_equal("is_near fails", geterror("is_near", 0, 1, 0.5))
    assert.is_equal("is_near fails", geterror2("is_near", 0, 1, 0.5))
    assert.is_equal("is_not_near fails", geterror("is_not_near", 0, 1, 1.5))
    assert.is_equal("is_not_near fails", geterror2("is_not_near", 0, 1, 1.5))
  end)

  it("Should use failure message for matches assertion", function()
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar"))
    assert.is_equal("matches fails", geterror("matches", "%d+", "0foobar", 2))
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar", 1, true))
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar", '2', true))
    assert.is_equal("matches fails", geterror2("matches", "%d+", "foobar"))
    assert.is_equal("no_match fails", geterror("no_match", "%w+", "12345"))
    assert.is_equal("no_match fails", geterror2("no_match", "%w+", "12345"))
  end)

  it("Should use failure message for has_error assertion", function()
    assert.is_equal("has_error fails", geterror("has_error", function()end, nil))
    assert.is_equal("has_error fails", geterror2("has_error", function()end, nil))
    assert.is_equal("has_no_error fails", geterror("has_no_error", error, nil))
    assert.is_equal("has_no_error fails", geterror2("has_no_error", error, nil))
  end)

  it("Should use failure message for error_matches assertion", function()
    assert.is_equal("error_matches fails", geterror("error_matches", function()end, ""))
    assert.is_equal("error_matches fails", geterror("error_matches", function() error("1string") end, "%d+", 2))
    assert.is_equal("error_matches fails", geterror("error_matches", function() error("1string") end, "xyz", 2, true))
    assert.is_equal("error_matches fails", geterror2("error_matches", function()end, ""))
    assert.is_equal("no_error_matches fails", geterror("no_error_matches", function() error("string") end, "string"))
    assert.is_equal("no_error_matches fails", geterror2("no_error_matches", function() error("string") end, "string"))
  end)

  it("Should use failure message for returned_arguments assertion", function()
    assert.is_equal("returned_arguments fails", geterror2("returned_arguments", 4, 1, 2, 3))
    assert.is_equal("not_returned_arguments fails", geterror2("not_returned_arguments", 4, 1, 2, 3, 4))
  end)

  it("Should convert objects to string", function()
    local t = setmetatable({},{__tostring=function(t) return "empty table" end})
    assert.is_equal("(table) { }", geterror("is_true", false, {}))
    assert.is_equal("(number) 999", geterror("is_true", false, 999))
    assert.is_equal("(boolean) true", geterror("is_true", false, true))
    assert.is_equal("(boolean) false", geterror("is_true", false, false))
    assert.is_equal("empty table", geterror("is_true", false, t))

    assert.is_equal("(table) { }", geterror2("is_true", false, {}))
    assert.is_equal("(number) 999", geterror2("is_true", false, 999))
    assert.is_equal("(boolean) true", geterror2("is_true", false, true))
    assert.is_equal("(boolean) false", geterror2("is_true", false, false))
    assert.is_equal("empty table", geterror2("is_true", false, t))
  end)

end)

for _,ss in ipairs({"spy", "stub"}) do
  describe("Output testing " .. ss .. " using custom failure message", function()
    local test = {key = function() return "derp" end}

    local geterror = function(key, args, ...)
      local err = select('#', ...) == 0 and key .. " failed" or ...
      local success, message = pcall(assert[ss](test.key, err)[key], unpack(args))
      if message == nil then return nil end
      message = tostring(message):gsub("\n.*", ""):gsub("^.-:%d+: ", "", 1)
      return message
    end

    local geterror2 = function(key, args, ...)
      local err = select('#', ...) == 0 and key .. " failed" or ...
      local success, message = pcall(assert.message(err).spy(test.key)[key], unpack(args))
      if message == nil then return nil end
      message = tostring(message):gsub("\n.*", ""):gsub("^.-:%d+: ", "", 1)
      return message
    end

    before_each(function()
      if ss == "spy" then
        spy.on(test, "key")
      else
        stub(test, "key").returns("derp")
      end
    end)

    after_each(function()
      test.key:revert()
    end)

    it("Should use standard failure message if none provided for called", function()
      local err1 = geterror("was_called", {}, nil)
      local err2 = geterror2("was_called", {}, nil)
      local ok1 = err1:find("^Expected")
      local ok2 = err2:find("^Expected")
      assert(ok1, "Output check for called failed\n    " .. err1:gsub("\n","\n    "))
      assert(ok2, "Output check for called failed\n    " .. err2:gsub("\n","\n    "))
    end)

    it("Should use failure message for " .. ss .. " called assertion", function()
      assert.is_equal("was_called failed", geterror("was_called", {}))
      assert.is_equal("was_called failed", geterror2("was_called", {}))
      assert.is_equal("was_not_called failed", geterror("was_not_called", {0}))
      assert.is_equal("was_not_called failed", geterror2("was_not_called", {0}))
    end)

    it("Should use failure message for " .. ss .. " called_at_least assertion", function()
      assert.is_equal("was_called_at_least failed", geterror("was_called_at_least", {1}))
      assert.is_equal("was_called_at_least failed", geterror2("was_called_at_least", {1}))
      assert.is_equal("was_not_called_at_least failed", geterror("was_not_called_at_least", {0}))
      assert.is_equal("was_not_called_at_least failed", geterror2("was_not_called_at_least", {0}))
    end)

    it("Should use failure message for " .. ss .. " called_at_most assertion", function()
      test.key()
      assert.is_equal("was_called_at_most failed", geterror("was_called_at_most", {0}))
      assert.is_equal("was_called_at_most failed", geterror2("was_called_at_most", {0}))
      assert.is_equal("was_not_called_at_most failed", geterror("was_not_called_at_most", {1}))
      assert.is_equal("was_not_called_at_most failed", geterror2("was_not_called_at_most", {1}))
    end)

    it("Should use failure message for " .. ss .. " called_more_than assertion", function()
      test.key()
      assert.is_equal("was_called_more_than failed", geterror("was_called_more_than", {1}))
      assert.is_equal("was_called_more_than failed", geterror2("was_called_more_than", {1}))
      assert.is_equal("was_not_called_more_than failed", geterror("was_not_called_more_than", {0}))
      assert.is_equal("was_not_called_more_than failed", geterror2("was_not_called_more_than", {0}))
    end)

    it("Should use failure message for " .. ss .. " called_less_than assertion", function()
      test.key()
      assert.is_equal("was_called_less_than failed", geterror("was_called_less_than", {1}))
      assert.is_equal("was_called_less_than failed", geterror2("was_called_less_than", {1}))
      assert.is_equal("was_not_called_less_than failed", geterror("was_not_called_less_than", {2}))
      assert.is_equal("was_not_called_less_than failed", geterror2("was_not_called_less_than", {2}))
    end)

    it("Should use standard failure message if none provided for called_with", function()
      local err1 = geterror("was_called_with", {}, nil)
      local err2 = geterror("was_called_with", {}, nil)
      local ok1 = err1:find("^Function")
      local ok2 = err2:find("^Function")
      assert(ok1, "Output check for called_with failed\n    " .. err1:gsub("\n","\n    "))
      assert(ok2, "Output check for called_with failed\n    " .. err2:gsub("\n","\n    "))
    end)

    it("Should use failure message for " .. ss .. " called_with assertion", function()
      test.key()
      assert.is_equal("was_called_with failed", geterror("was_called_with", {1}))
      assert.is_equal("was_called_with failed", geterror2("was_called_with", {1}))
      assert.is_equal("was_not_called_with failed", geterror("was_not_called_with", {}))
      assert.is_equal("was_not_called_with failed", geterror2("was_not_called_with", {}))
    end)

    it("Should use failure message for " .. ss .. " returned_with assertion", function()
      test.key()
      assert.is_equal("was_returned_with failed", geterror("was_returned_with", {1}))
      assert.is_equal("was_returned_with failed", geterror2("was_returned_with", {1}))
      assert.is_equal("was_not_returned_with failed", geterror("was_not_returned_with", {"derp"}))
      assert.is_equal("was_not_returned_with failed", geterror2("was_not_returned_with", {"derp"}))
    end)

    it("Should convert objects to string", function()
      local t = setmetatable({},{__tostring=function(t) return "empty table" end})
      assert.is_equal("(table) { }", geterror("was_called", {}, {}))
      assert.is_equal("(number) 999", geterror("was_called", {}, 999))
      assert.is_equal("(boolean) true", geterror("was_called", {}, true))
      assert.is_equal("(boolean) false", geterror("was_called", {}, false))
      assert.is_equal("empty table", geterror("was_called", {}, t))

      assert.is_equal("(table) { }", geterror2("was_called", {}, {}))
      assert.is_equal("(number) 999", geterror2("was_called", {}, 999))
      assert.is_equal("(boolean) true", geterror2("was_called", {}, true))
      assert.is_equal("(boolean) false", geterror2("was_called", {}, false))
      assert.is_equal("empty table", geterror2("was_called", {}, t))
    end)

  end)
end
