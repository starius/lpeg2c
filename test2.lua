local lpeg = require 'lpeg'
local pattern = lpeg.P 'abc'

local codegen = require 'lpeg2c.codegen'
print(codegen(pattern))
