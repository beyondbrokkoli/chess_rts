/* tenant/tenant_input.c */

EXPORT int vx_input_last_key(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;
    return E_A(g_engine.mailbox.tenants[win_id].last_key_pressed, 0);
}

EXPORT int vx_input_get_active_window(void) {
    return L(g_engine.mailbox.active_window);
}

EXPORT int vx_input_mouse_btn(int win_id, int btn) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;
    if (btn == 0) return L(g_engine.mailbox.tenants[win_id].mouse_left);
    if (btn == 1) return L(g_engine.mailbox.tenants[win_id].mouse_right);
    return 0;
}

EXPORT float vx_input_mouse_x(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0.0f;
    return L(g_engine.mailbox.tenants[win_id].mouse_x);
}

EXPORT float vx_input_mouse_y(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0.0f;
    return L(g_engine.mailbox.tenants[win_id].mouse_y);
}

EXPORT float vx_input_click_x(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return -1.0f;
    return L(g_engine.mailbox.tenants[win_id].click_x);
}

EXPORT float vx_input_click_y(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return -1.0f;
    return L(g_engine.mailbox.tenants[win_id].click_y);
}

EXPORT int vx_input_is_captured(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;
    return L(g_engine.mailbox.tenants[win_id].mouse_captured);
}

EXPORT uint32_t vx_input_wasd(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;
    return L(g_engine.mailbox.tenants[win_id].wasd_mask);
}

EXPORT float vx_input_mouse_dx(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0.0f;
    return E_A(g_engine.mailbox.tenants[win_id].mouse_dx, 0.0f);
}

EXPORT float vx_input_mouse_dy(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0.0f;
    return E_A(g_engine.mailbox.tenants[win_id].mouse_dy, 0.0f);
}

EXPORT int vx_input_spacebar(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;
    return L(g_engine.mailbox.tenants[win_id].key_space);
}
