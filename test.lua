local lpeg = require 'lpeg'
local parseLpegByteCode = require 'lpeg2c.parseLpegByteCode'

local pattern = lpeg.P 'abc'
--lpeg.ptree(pattern)
--lpeg.pcode(pattern)

pattern2 = parseLpegByteCode(pattern)
