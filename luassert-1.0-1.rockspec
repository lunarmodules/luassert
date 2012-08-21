package = "luassert"
version = "1.0-1"
source = {
  url = "https://github.com/downloads/Olivine-Labs/luassert/luassert-1.0.tar.gz"
}
description = {
  summary = "Lua Assertions Extension",
  detailed = [[
    Adds a framework that allows registering new assertions
    without compromising builtin assertion functionality.
  ]],
  homepage = "http://olivinelabs.com/busted/",
  license = "MIT <http://opensource.org/licenses/MIT>"
}
dependencies = {
  "lua >= 5.1",
  "say >= 1.0-1"
}
build = {
  type = "builtin",
  modules = {
    ["luassert.util"] = "util.lua",
    ["luassert.spy"] = "spy.lua",
    ["luassert.stub"] = "stub.lua",
    ["luassert.assert"] = "assert.lua",
    ["luassert.modifiers"] = "modifiers.lua",
    ["luassert.assertions"] = "assertions.lua",
    ["luassert.mock"] = "mock.lua",
    ["luassert.all"] = "all.lua"
  }
}
