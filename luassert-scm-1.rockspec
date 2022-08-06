package = "luassert"
version = "scm-1"
source = {
  url = "git://github.com/Olivine-Labs/luassert.git",
  --dir = "luassert-1.8.0"
  tag = "master"
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
  "say >= 1.2-1"
}
build = {
  type = "builtin",
  modules = {
    ["luassert.compatibility"] = "src/compatibility.lua",
    ["luassert.state"] = "src/state.lua",
    ["luassert.util"] = "src/util.lua",
    ["luassert.spy"] = "src/spy.lua",
    ["luassert.stub"] = "src/stub.lua",
    ["luassert.assert"] = "src/assert.lua",
    ["luassert.modifiers"] = "src/modifiers.lua",
    ["luassert.assertions"] = "src/assertions.lua",
    ["luassert.array"] = "src/array.lua",
    ["luassert.namespaces"] = "src/namespaces.lua",
    ["luassert.match"] = "src/match.lua",
    ["luassert.mock"] = "src/mock.lua",
    ["luassert.init"] = "src/init.lua",
    ["luassert.matchers.init"] = "src/matchers/init.lua",
    ["luassert.matchers.core"] = "src/matchers/core.lua",
    ["luassert.matchers.composite"] = "src/matchers/composite.lua",
    ["luassert.formatters.init"] = "src/formatters/init.lua",
    ["luassert.formatters.binarystring"] = "src/formatters/binarystring.lua",
    ["luassert.languages.ar"] = "src/languages/ar.lua",
    ["luassert.languages.de"] = "src/languages/de.lua",
    ["luassert.languages.en"] = "src/languages/en.lua",
    ["luassert.languages.fr"] = "src/languages/fr.lua",
    ["luassert.languages.is"] = "src/languages/is.lua",
    ["luassert.languages.ja"] = "src/languages/ja.lua",
    ["luassert.languages.nl"] = "src/languages/nl.lua",
    ["luassert.languages.ru"] = "src/languages/ru.lua",
    ["luassert.languages.ua"] = "src/languages/ua.lua",
    ["luassert.languages.zh"] = "src/languages/zh.lua",
  }
}
