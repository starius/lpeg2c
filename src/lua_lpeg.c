#include <lua.h>
#include <lauxlib.h>

#include "lpeg_all.h"
#include "compat.h"

static void addInstruction(lua_State* L,
        Instruction* i, int n, int offset) {
    lua_newtable(L);
    //
    // offset
    lua_pushinteger(L, offset);
    lua_setfield(L, -2, "offset");
    // name
    const char* name = lpeg_instName(i);
    lua_pushstring(L, name);
    lua_setfield(L, -2, "name");
    //
    if (lpeg_hasChar(i)) {
        char c = lpeg_instChar(i);
        lua_pushlstring(L, &c, 1);
        lua_setfield(L, -2, "char");
    }
    if (lpeg_hasCharset(i)) {
        const char* set = lpeg_instCharset(i);
        lua_pushlstring(L, set, CHARSETINSTSIZE);
        lua_setfield(L, -2, "charset");
    }
    if (lpeg_hasRef(i)) {
        int ref_offset = lpeg_instRef(i) + offset;
        lua_pushinteger(L, ref_offset);
        lua_setfield(L, -2, "ref");
    }
    if (lpeg_hasKey(i)) {
        int key = lpeg_instKey(i);
        lua_pushinteger(L, key);
        lua_setfield(L, -2, "key");
    }
    //
    lua_rawseti(L, -2, n);
}

// Arguments:
// 1. lpeg Pattern object
// Results:
// 1. Array of instructions
int parseLpegByteCode(lua_State* L) {
    Pattern* pattern = luaL_checkudata(L, 1, PATTERN_T);
    if (!pattern->code) {
        // Pattern is not compiled, call match with ''
        lua_getfield(L, 1, "match");
        lua_pushvalue(L, 1);
        lua_pushliteral(L, "");
        lua_call(L, 2, 0);
    }
    //
    lua_newtable(L);
    int codesize = pattern->codesize;
    Instruction* begin = pattern->code;
    Instruction* end = begin + codesize;
    Instruction* curr = begin;
    int n = 1;
    while (curr < end) {
        int offset = curr - begin;
        addInstruction(L, curr, n, offset);
        curr += lpeg_sizei(curr);
        n += 1;
    }
    return 1;
}

int luaopen_lpeg2c_parseLpegByteCode(lua_State* L) {
    lua_pushcfunction(L, parseLpegByteCode);
    return 1;
}
