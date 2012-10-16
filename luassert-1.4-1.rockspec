package = "luassert"
version = "1.4-1"
source = {
  url = "https://github.com/downloads/Olivine-Labs/luassert/luassert-1.4.tar.gz",
  dir = "luassert"
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
  "say >= 1.1-1"
}
build = {
  type = "builtin",
  modules = {
    ["luassert.util"] = "src/util.lua",
    ["luassert.spy"] = "src/spy.lua",
    ["luassert.stub"] = "src/stub.lua",
    ["luassert.assert"] = "src/assert.lua",
    ["luassert.modifiers"] = "src/modifiers.lua",
    ["luassert.assertions"] = "src/assertions.lua",
    ["luassert.mock"] = "src/mock.lua",
    ["luassert.init"] = "src/init.lua",
    ["luassert.formatters.init"] = "src/formatters/init.lua",
    ["luassert.formatters.binarystring"] = "src/formatters/binarystring.lua",
    ["luassert.languages.en"] = "src/languages/en.lua",
    ["luassert.languages.ar"] = "src/languages/ar.lua",
    ["luassert.languages.fr"] = "src/languages/fr.lua",
    ["luassert.languages.nl"] = "src/languages/nl.lua",
    ["luassert.languages.ru"] = "src/languages/ru.lua",
    ["luassert.languages.ua"] = "src/languages/ua.lua",
  }
}
