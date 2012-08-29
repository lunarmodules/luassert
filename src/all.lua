--setup luassert
assert = require 'luassert.assert'
require 'luassert.modifiers'
require 'luassert.assertions'

spy = require 'luassert.spy'
mock = require 'luassert.mock'
require 'luassert.languages.en'


--[[ 
this is seriously bad, lots of assumptions and globals, if busted needs 
them, busted should make them global in its own environment, but the 
luassert module itself should not create those globals (assert, spy and 
mock in this case)

rename this file to 'init.lua' so it can be called as
    local assert = require('luassert')
optional components can be added as;
    local spy = require('luassert.spy')
    local mock = require('luassert.mock')
    require('luassert.languages.abc')

    
proposed content;

local assert = require('luassert.assert')
-- load basic asserts
require('luassert.assertions')
require('luassert.modifiers')
-- load default language
require('luassert.languages.en')
return assert


]]--
