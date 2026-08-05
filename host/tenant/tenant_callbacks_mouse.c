/* tenant/tenant_callbacks_mouse.c */

void glfw_cursor_callback(GLFWwindow* window, double xpos, double ypos) {
    int id = (int)(intptr_t)glfwGetWindowUserPointer(window);
    if (id < 0 || id >= MAX_WINDOWS) return;

    S(g_engine.mailbox.tenants[id].mouse_x, (float)xpos);
    S(g_engine.mailbox.tenants[id].mouse_y, (float)ypos);

    if (first_mouse[id]) {
        last_mx[id] = xpos;
        last_my[id] = ypos;
        first_mouse[id] = false;
    }

    float dx = (float)(xpos - last_mx[id]);
    float dy = (float)(ypos - last_my[id]);
    last_mx[id] = xpos;
    last_my[id] = ypos;

    float current_dx = L_R(g_engine.mailbox.tenants[id].mouse_dx);
    float new_dx;
    do { new_dx = current_dx + dx; }
    while (!CWX(g_engine.mailbox.tenants[id].mouse_dx, current_dx, new_dx));

    float current_dy = L_R(g_engine.mailbox.tenants[id].mouse_dy);
    float new_dy;
    do { new_dy = current_dy + dy; }
    while (!CWX(g_engine.mailbox.tenants[id].mouse_dy, current_dy, new_dy));
}

void glfw_mouse_button_callback(GLFWwindow* window, int button, int action, int mods) {
    int id = (int)(intptr_t)glfwGetWindowUserPointer(window);
    if (id < 0 || id >= MAX_WINDOWS) return;

    if (action == GLFW_PRESS) {
        S(g_engine.mailbox.active_window, id);
    }

    if (button == GLFW_MOUSE_BUTTON_LEFT) {
        if (action == GLFW_PRESS) {
            double cx, cy;
            glfwGetCursorPos(window, &cx, &cy);
            S(g_engine.mailbox.tenants[id].click_x, (float)cx);
            S(g_engine.mailbox.tenants[id].click_y, (float)cy);
            S(g_engine.mailbox.tenants[id].mouse_left, 1);
        } else {
            S(g_engine.mailbox.tenants[id].mouse_left, 0);
        }
    } else if (button == GLFW_MOUSE_BUTTON_RIGHT) {
        S(g_engine.mailbox.tenants[id].mouse_right, (action == GLFW_PRESS) ? 1 : 0);
    }
}
