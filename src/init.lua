local assert = require('luassert.assert')

-- load basic asserts
require('luassert.assertions')
require('luassert.modifiers')
require('luassert.formatters')

-- load default language
require('luassert.languages.en')

return assert
