local lpeg = require 'lpeg'
local pattern = lpeg.P 'abc'

local lpeg2c = require 'lpeg2c'
print(lpeg2c(pattern))
