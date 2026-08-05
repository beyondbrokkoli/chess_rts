/* host/main_headless.c */

// 1. SYSTEM LIBRARIES
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

#include <luajit-2.1/lua.h>
#include <luajit-2.1/lualib.h>
#include <luajit-2.1/lauxlib.h>

// 3.5. CORE HOST DOMAIN
// Provides EXPORT, SLEEP_MS, and atomic macros required by the network backend
#include "sys_sync.c"

// 5. HEADLESS ORCHESTRATION
// Simple stub for the shutdown hook requested by headless_api.lua
void vx_core_shutdown(void) {
    printf("[C-CORE] Headless shutdown triggered.\n");
    exit(0);
}

int main(int argc, char** argv) {
    printf("[C-CORE] Booting Headless Unity Build...\n");

    lua_State* Ls = luaL_newstate();
    if (!Ls) {
        printf("[FATAL] Failed to initialize LuaJIT.\n");
        return 1;
    }

    luaL_openlibs(Ls);

    // --- NEW INJECTION: Construct the global 'arg' table ---
    lua_newtable(Ls);
    for (int i = 0; i < argc; i++) {
        lua_pushstring(Ls, argv[i]);
        lua_rawseti(Ls, -2, i); // arg[i] = argv[i]
    }
    lua_setglobal(Ls, "arg");

    printf("[C-CORE] Routing to scripts/bot.lua...\n");
    if (luaL_dofile(Ls, "scripts/bot.lua") != LUA_OK) {
        printf("\n[LUA FATAL ERROR] %s\n", lua_tostring(Ls, -1));
        lua_close(Ls);
        return 1;
    }

    lua_close(Ls);
    printf("[C-CORE] Headless VM Destroyed. Exiting.\n");
    return 0;
}
