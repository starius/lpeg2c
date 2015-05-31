local lpeg = require 'lpeg'
local lpeg2c = require 'lpeg2c'

local function genParenthesis()
    local t = {}
    math.randomseed(0)
    for i = 1, 100 do
        table.insert(t, '(')
    end
    for i = 1, 9999999 do
        if math.random(1, 2) == 1 then
            table.insert(t, '(')
        else
            table.insert(t, ')')
        end
    end
    return table.concat(t)
end

local pattern = lpeg.P{
    "(" * (lpeg.V(1))^0 * ")"
}

local pattern2 = lpeg2c(pattern)
local text = genParenthesis()
local t1 = os.clock()
local res = pattern2(text)
local t2 = os.clock()
print(res, t2 - t1)
local check = text:match('%b()')
assert(res == #check + 1)
