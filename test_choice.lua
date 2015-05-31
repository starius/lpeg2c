local lpeg = require 'lpeg'
local lpeg2c = require 'lpeg2c'

local pattern = lpeg.P(lpeg.P 'abc' + lpeg.P 'acb')

lpeg.pcode(pattern)


local pattern2 = lpeg2c(pattern)
assert(pattern2('abc') == 4)
assert(pattern2('acb') == 4)
assert(pattern2('bca') == nil)
