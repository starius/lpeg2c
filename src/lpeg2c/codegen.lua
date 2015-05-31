local numtab = {}
for i = 0, 255 do
    numtab[string.char(i)] = ("%3d,"):format(i)
end
local function bin2c(str)
    str = str .. '\0'
    return str:gsub(".", numtab):gsub(("."):rep(80), "%0\n")
end

local function parsePattern(pattern)
    local lpeg = require 'lpeg'
    local parse = require 'lpeg2c.parseLpegByteCode'
    local pattern = lpeg.P(pattern)
    return parse(pattern)
end

local function rawYield(text)
    coroutine.yield(text)
end

local function yield(text, ...)
    rawYield(text:format(...) .. '\n')
end

local function functionName(code)
    return code.name .. code.offset
end

local function functionDecl(name)
    local decl = [[static const char* %s(const char* s,
        MatchState* mstate)]]
    return decl:format(name)
end

local function declareFunctions(codes)
    for _, code in ipairs(codes) do
        local name = functionName(code)
        yield(functionDecl(name) .. ';')
    end
end

local functions = {}

functions['end'] = function(code)
    yield('mstate->capture[mstate->captop].kind = Cclose;')
    yield('mstate->capture[mstate->captop].s = NULL;')
    yield('return s;')
end

function functions.giveup(code)
    yield('return NULL;')
end

function functions.ret(code)
    yield('return s;')
end

function functions.any(code)
    yield('if (s < mstate->e) {')
    yield('return %s(s+1, mstate);', functionName(code.next))
    yield('} else {')
    yield('return LPEG2C_FAIL;')
    yield('}')
end

function functions.testany(code)
    yield('if (s < mstate->e) {')
    yield('return %s(s, mstate);', functionName(code.next))
    yield('} else {')
    yield('return %s(s, mstate);', functionName(code.pointed))
    yield('}')
end

function functions.char(code)
    yield('if (s < mstate->e && *s == %d) {', code.char:byte())
    yield('return %s(s+1, mstate);', functionName(code.next))
    yield('} else {')
    yield('return LPEG2C_FAIL;')
    yield('}')
end

function functions.testchar(code)
    yield('if (s < mstate->e && *s == %d) {', code.char:byte())
    yield('return %s(s, mstate);', functionName(code.next))
    yield('} else {')
    yield('return %s(s, mstate);', functionName(code.pointed))
    yield('}')
end

function functions.set(code)
    yield('if (s < mstate->e && testchar({%s}, *s)) {',
        bin2c(code.charset))
    yield('return %s(s+1, mstate);', functionName(code.next))
    yield('} else {')
    yield('return LPEG2C_FAIL;')
    yield('}')
end

function functions.testset(code)
    yield('if (s < mstate->e && testchar({%s}, *s)) {',
        bin2c(code.charset))
    yield('return %s(s, mstate);', functionName(code.next))
    yield('} else {')
    yield('return %s(s, mstate);', functionName(code.pointed))
    yield('}')
end

function functions.behind(code)
    yield('if (%d > s - mstate->o) {', code.n)
    yield('return LPEG2C_FAIL;')
    yield('} else {')
    yield('return %s(s-%d, mstate);',
        functionName(code.next), code.n)
    yield('}')
end

function functions.span(code)
    yield('for (; s < mstate->e; s++) {')
    yield('if (!testchar({%s}, *s)) {', bin2c(code.charset))
    yield('break;')
    yield('}')
    yield('}')
    yield('return %s(s, mstate);', functionName(code.next))
end

function functions.jmp(code)
    yield('return %s(s, mstate);', functionName(code.pointed))
end

function functions.choice(code)
    yield('int captop = mstate->captop;')
    yield('const char* try1 = %s(s, mstate);',
        functionName(code.next))
    yield('if (try1 == LPEG2C_FAIL) {')
    yield('mstate->captop = captop;')
    yield('return %s(s, mstate);', functionName(code.pointed))
    yield('} else {')
    yield('return try1;')
    yield('}')
end

function functions.call(code)
    yield('const char* try1 = %s(s, mstate);',
        functionName(code.pointed))
    yield('if (try1 == LPEG2C_FAIL) {')
    yield('return LPEG2C_FAIL;')
    yield('} else {')
    yield('return %s(try1, mstate);', functionName(code.next))
    yield('}')
end

local function defineFunction(code)
    local name = functionName(code)
    local decl = functionDecl(name)
    yield(decl)
    yield('{')
    -- define body
    local name = code.name
    local f = assert(functions[name])
    f(code)
    yield('}')
end

local function defineFunctions(codes)
    for _, code in ipairs(codes) do
        defineFunction(code)
    end
end

local function defineMatcher(codes)
    local first = assert(codes[1])
    yield('static const char* lpeg2c_match(MatchState* mstate)')
    yield('{')
    yield('const char* r = %s(mstate->s, mstate);',
        functionName(first))
    yield('if (r == LPEG2C_FAIL) {')
    yield('r = NULL;')
    yield('}')
    yield('return r;')
    yield('}')
end

local function setPointers(codes)
    for _, code in ipairs(codes) do
        code.next = codes[_ + 1]
    end
    local offset2code = {}
    for _, code in ipairs(codes) do
        offset2code[code.offset] = code
    end
    for _, code in ipairs(codes) do
        if code.ref then
            code.pointed = assert(offset2code[code.ref])
        end
    end
end

local function generate(pattern)
    return coroutine.wrap(function()
        local codes = parsePattern(pattern)
        setPointers(codes)
        rawYield(require 'lpeg2c.prologue_c')
        yield('')
        declareFunctions(codes)
        yield('')
        defineFunctions(codes)
        yield('')
        defineMatcher(codes)
        yield('')
        rawYield(require 'lpeg2c.epilogue_c')
    end)
end

return function(pattern)
    local t = {}
    for text in generate(pattern) do
        table.insert(t, text)
    end
    return table.concat(t)
end
