local cmd = 'gcc -O0 -g -shared -fPIC ' ..
    ' -I /usr/include/lua5.1/ %s -o %s -llua5.1'

return function(pattern)
    local codegen = require 'lpeg2c.codegen'
    local c = codegen(pattern)
    local tmp = os.tmpname()
    local c_filename = tmp .. '.c'
    local c_file = io.open(c_filename, 'w')
    c_file:write(c)
    c_file:close()
    local so_filename = tmp .. '.so'
    local cmd = cmd:format(c_filename, so_filename)
    os.execute(cmd)
    local f = assert(package.loadlib(
        so_filename, 'lua_lpeg2c_match'))
    os.remove(so_filename)
    os.remove(c_filename)
    os.remove(tmp)
    return f
end
