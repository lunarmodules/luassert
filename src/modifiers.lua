-- module will not return anything, only register assertions/modifiers with the main assert engine
local assert = require('luassert.assert')

local function is(state)
  return state
end

local function is_not(state)
  state.mod = not state.mod
  return state
end

assert:register("modifier", "is", is)
assert:register("modifier", "are", is)
assert:register("modifier", "was", is)
assert:register("modifier", "has", is)
assert:register("modifier", "is_not", is_not)
assert:register("modifier", "are_not", is_not)
assert:register("modifier", "was_not", is_not)
assert:register("modifier", "has_no", is_not)
