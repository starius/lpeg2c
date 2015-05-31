local lpeg = require 'lpeg'
local lpeg2c = require 'lpeg2c'

local pattern = lpeg.P 'abc'
--lpeg.ptree(pattern)
--lpeg.pcode(pattern)

pattern2 = lpeg2c.parseLpegByteCode(pattern)
