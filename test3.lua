local lpeg = require 'lpeg'
local pattern = lpeg.P 'abc'

local lpeg2c = require 'lpeg2c'
local pattern2 = lpeg2c(pattern)
assert(pattern2('abc') == 4)
