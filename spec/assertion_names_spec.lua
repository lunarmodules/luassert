local assert = require "luassert"

describe("Custom assertion names", function()
  local long_calls, short_calls

  before_each(function()
    long_calls, short_calls = 0, 0
    assert:register("assertion", "three_words_token", function(state, arguments)
      long_calls = long_calls + 1
      return arguments[1]
    end)
    assert:register("assertion", "words_token", function(state, arguments)
      short_calls = short_calls + 1
      return arguments[1]
    end)
  end)

  after_each(function()
    assert:unregister("assertion", "three_words_token")
    assert:unregister("assertion", "words_token")
  end)

  it("matches a three-word assertion without a registered suffix", function()
    assert:unregister("assertion", "words_token")

    assert.three_words_token(true)

    assert.equal(1, long_calls)
    assert.equal(0, short_calls)
  end)

  it("keeps the shorter assertion callable", function()
    assert.words_token(true)
    assert.is_words_token(true)

    assert.equal(0, long_calls)
    assert.equal(2, short_calls)
  end)

  it("prefers a three-word assertion over its registered suffix", function()
    assert.three_words_token(true)

    assert.equal(1, long_calls)
    assert.equal(0, short_calls)
  end)

  it("matches the longer assertion with chained modifiers", function()
    assert.is_three_words_token(true)
    assert.is.three_words_token(true)

    assert.equal(2, long_calls)
    assert.equal(0, short_calls)
  end)

  it("applies negation to the longer assertion", function()
    assert.is_not_three_words_token(false)
    assert.is.Not.three_words_token(false)
    assert.has_error(function()
      assert.is_not_three_words_token(true)
    end)

    assert.equal(3, long_calls)
    assert.equal(0, short_calls)
  end)
end)
