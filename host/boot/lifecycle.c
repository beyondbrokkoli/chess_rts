/* host/lifecycle.c */

EXPORT int vx_core_is_running(void) {
    return L_R(g_engine.mailbox.is_running);
}

EXPORT void vx_core_shutdown(void) {
    S(g_engine.mailbox.is_running, 0);
}

EXPORT void vx_core_mark_finished(void) {
    S(g_engine.mailbox.lua_finished, 1);
}
