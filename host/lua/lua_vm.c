/* host/lua_vm.c */

static THREAD_FUNC lua_co_overlord_loop(void* arg) {
    printf("[LUA-OS-THREAD] Booting Lua VM...\n");

    lua_State* Ls = luaL_newstate();
    luaL_openlibs(Ls);

    // --- NEW INJECTION: Construct the global 'arg' table ---
    lua_newtable(Ls);
    for (int i = 0; i < g_host_argc; i++) {
        lua_pushstring(Ls, g_host_argv[i]);
        lua_rawseti(Ls, -2, i); // arg[i] = g_host_argv[i]
    }
    lua_setglobal(Ls, "arg");

    if (luaL_dofile(Ls, "staging/main.lua") != LUA_OK) {
        printf("\n[LUA FATAL ERROR] %s\n", lua_tostring(Ls, -1));
        vx_core_shutdown();
    }

    lua_close(Ls);
    printf("[LUA-OS-THREAD] VM Destroyed.\n");
    return THREAD_RETURN_VAL;
}
