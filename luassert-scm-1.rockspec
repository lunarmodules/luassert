local package_name = "luassert"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "lunarmodules"
local github_repo_name = package_name

rockspec_format = "3.0"
package = package_name
version = package_version .. "-" .. rockspec_revision

source = {
  url = "git+https://github.com/" .. github_account_name .. "/" .. github_repo_name .. ".git"
}

if package_version == "scm" then source.branch = "master" else source.tag = "v" .. package_version end

description = {
  summary = "Lua assertions extension",
  detailed = [[
    Adds a framework that allows registering new assertions
    without compromising builtin assertion functionality.
  ]],
  homepage = "https://lunarmodules.github.io/busted/",
  license = "MIT <http://opensource.org/licenses/MIT>"
}

dependencies = {
  "lua >= 5.1",
  "say >= 1.4.0-1"
}

test_dependencies = {
  "busted",
}

test = {
  type = "busted",
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
