local function parsePattern(pattern)
    local lpeg = require 'lpeg'
    local parse = require 'lpeg2c.parseLpegByteCode'
    local pattern = lpeg.P 'abc'
    return parse(pattern)
end

local function yield(text, ...)
    coroutine.yield(text:format(...) .. '\n')
end

local function functionName(code)
    return code.name .. code.offset
end

local function functionDecl(name)
    local decl = [[char* %s(const char* begin,
        const char* end, const char* curr,
        int captop)]]
    return decl:format(name)
end

local function declareFunctions(codes)
    for _, code in ipairs(codes) do
        local name = functionName(code)
        local decl = functionDecl(name) .. ';'
        yield(decl)
    end
end

local function generate(pattern)
    return coroutine.wrap(function(pattern)
        local codes = parsePattern(pattern)
        declareFunctions(codes)
    end)
end

return function(pattern)
    local t = {}
    for text in generate(pattern) do
        table.insert(t, text)
    end
    return table.concat(t)
end
