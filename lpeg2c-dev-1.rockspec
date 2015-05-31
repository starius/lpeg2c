package = "lpeg2c"
version = "dev-1"
source = {
    url = "git@github.com:starius/lpeg2c.git",
}
description = {
    summary = " Convert LPeg pattern to C code ",
    homepage = "https://github.com/starius/lpeg2c",
    license = "MIT",
}
dependencies = {
    "lua >= 5.1",
}
external_dependencies = {
    LPEG = {
        header = "lptypes.h",
    },
}
build = {
    type = "builtin",
    modules = {
        ['lpeg2c.parseLpegByteCode'] = {
            sources = {
                "src/c/lpeg_all.c",
                "src/c/lua_lpeg.c",
            },
            incdirs = {"$(LPEG_INCDIR)", '.'},
        },
        ['lpeg2c'] = 'src/lpeg2c/lpeg2c.lua',
        ['lpeg2c.codegen'] = 'src/lpeg2c/codegen.lua',
        ['lpeg2c.prologue_c'] = 'src/lpeg2c/prologue_c.lua',
        ['lpeg2c.epilogue_c'] = 'src/lpeg2c/epilogue_c.lua',
    },
}
