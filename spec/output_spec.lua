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
    message = tostring(message):gsub("\n.*", "")
    return message
  end

  it("Should use failure message for is_true assertion", function()
    assert.is_equal("is_true fails", geterror("is_true", false))
    assert.is_equal("is_not_true fails", geterror("is_not_true", true))
  end)

  it("Should use failure message for is_false assertion", function()
    assert.is_equal("is_false fails", geterror("is_false", true))
    assert.is_equal("is_not_false fails", geterror("is_not_false", false))
  end)

  it("Should use failure message for is_truthy assertion", function()
    assert.is_equal("is_truthy fails", geterror("is_truthy", false))
    assert.is_equal("is_not_truthy fails", geterror("is_not_truthy", true))
  end)

  it("Should use failure message for is_falsy assertion", function()
    assert.is_equal("is_falsy fails", geterror("is_falsy", true))
    assert.is_equal("is_not_falsy fails", geterror("is_not_falsy", false))
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

    local thread = coroutine.create(function() end)
    assert.is_equal("is_not_boolean fails", geterror("is_not_boolean", true))
    assert.is_equal("is_not_number fails", geterror("is_not_number", 0))
    assert.is_equal("is_not_string fails", geterror("is_not_string", ''))
    assert.is_equal("is_not_table fails", geterror("is_not_table", {}))
    assert.is_equal("is_not_nil fails", geterror("is_not_nil", nil))
    assert.is_equal("is_not_userdata fails", geterror("is_not_userdata", io.stdin))
    assert.is_equal("is_not_function fails", geterror("is_not_function", function()end))
    assert.is_equal("is_not_thread fails", geterror("is_not_thread", thread))
  end)

  it("Should use failure message for is_equal assertion", function()
    assert.is_equal("equals fails", geterror("equals", true, false))
    assert.is_equal("not_equals fails", geterror("not_equals", true, true))
  end)

  it("Should use failure message for is_same assertion", function()
    assert.is_equal("same fails", geterror("same", true, false))
    assert.is_equal("not_same fails", geterror("not_same", true, true))
  end)

  it("Should use failure message for is_same assertion: table-table", function()
    assert.is_equal("same fails", geterror("same", {}, {1}))
    assert.is_equal("not_same fails", geterror("not_same", {}, {}))
  end)

  it("Should use failure message for is_unique assertion: shallow compare", function()
    assert.is_equal("unique fails", geterror("unique", {1, 1}))
    assert.is_equal("not_unique fails", geterror("not_unique", {1, 0}))
  end)

  it("Should use failure message for is_unique assertion: nil deep compare", function()
    assert.is_equal("unique fails", geterror("unique", {1, 1}, nil))
    assert.is_equal("not_unique fails", geterror("not_unique", {1, 0}, nil))
  end)

  it("Should use failure message for is_unique assertion: deep compare", function()
    assert.is_equal("unique fails", geterror("unique", {{1}, {1}}, true))
    assert.is_equal("not_unique fails", geterror("not_unique", {{0}, {1}}, true))
  end)

  it("Should use failure message for is_unique assertion: deep compare 2", function()
    local err1 = geterror("unique", {{1}, {1}}, "unique deep compare 2 fails", true)
    local err2 = geterror("not_unique", {{0}, {1}}, "not unique deep compare 2 fails", true)
    assert.is_equal("unique deep compare 2 fails", err1)
    assert.is_equal("not unique deep compare 2 fails", err2)
  end)

  it("Should use failure message for is_near assertion", function()
    assert.is_equal("is_near fails", geterror("is_near", 0, 1, 0.5))
    assert.is_equal("is_not_near fails", geterror("is_not_near", 0, 1, 1.5))
  end)

  it("Should use failure message for matches assertion", function()
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar"))
    assert.is_equal("matches fails", geterror("matches", "%d+", "0foobar", 2))
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar", 1, true))
    assert.is_equal("matches fails", geterror("matches", "%d+", "foobar", '2', true))
    assert.is_equal("no_match fails", geterror("no_match", "%w+", "12345"))
  end)

  it("Should use failure message for has_error assertion", function()
    assert.is_equal("has_error fails", geterror("has_error", function()end, nil))
    assert.is_equal("has_no_error fails", geterror("has_no_error", error, nil))
  end)

end)
