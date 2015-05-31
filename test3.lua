local lpeg = require 'lpeg'
local lpeg2c = require 'lpeg2c'

local pattern = lpeg.P 'abc'
local pattern2 = lpeg2c(pattern)
assert(pattern2('abc') == 4)

local pattern = lpeg.P{
    "(" * (lpeg.V(1))^0 * ")"
}
local pattern2 = lpeg2c(pattern)
assert(pattern2('(())') == 5)
