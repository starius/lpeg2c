git submodule update --init
luarocks make --local LPEG_INCDIR=lpeg CFLAGS='-g -O0 -shared -fPIC'
