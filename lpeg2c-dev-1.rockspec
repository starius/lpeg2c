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
                "src/lpeg_all.c",
                "src/lua_lpeg.c",
            },
            incdirs = {"$(LPEG_INCDIR)", '.'},
        },
        ['lpeg2c.codegen'] = 'src/codegen.lua',
        ['lpeg2c.prologue_c'] = 'src/prologue_c.lua',
        ['lpeg2c.epilogue_c'] = 'src/epilogue_c.lua',
    },
}
