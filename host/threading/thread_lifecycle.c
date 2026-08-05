/* host/thread_lifecycle.c */

// Forward declare the worker loops from the render domain
THREAD_FUNC render_thread_loop(void* arg);
THREAD_FUNC transfer_thread_loop(void* arg);

EXPORT void vx_thread_start(void) {
    S(g_render_thread_active,   1);
    S(g_transfer_thread_active, 1);
    g_render_thread   = vmath_thread_start(render_thread_loop,   NULL);
    g_transfer_thread = vmath_thread_start(transfer_thread_loop, NULL);
}

EXPORT void vx_thread_kill(void) {
    S(g_render_thread_active,   0);
    S(g_transfer_thread_active, 0);

    vmath_thread_join(g_render_thread);
    vmath_thread_join(g_transfer_thread);

    for (int i = 0; i < MAX_WINDOWS; i++) {
        S(g_ring.ready_idx[i], -1);
    }
    S(g_ring.locked_mask, 0);

    for (int i = 0; i < MAX_WINDOWS; i++) {
        if (g_window_wsi[i].device) {
            vkDeviceWaitIdle(g_window_wsi[i].device);
        }
        if (g_render_cmd_pools[i]) {
            vkDestroyCommandPool(g_window_wsi[i].device, g_render_cmd_pools[i], NULL);
            g_render_cmd_pools[i] = VK_NULL_HANDLE;
        }
        if (g_transfer_cmd_pools[i]) {
            vkDestroyCommandPool(g_window_wsi[i].device, g_transfer_cmd_pools[i], NULL);
            g_transfer_cmd_pools[i] = VK_NULL_HANDLE;
        }
        if (g_transfer_fences[i]) {
            vkDestroyFence(g_window_wsi[i].device, g_transfer_fences[i], NULL);
            g_transfer_fences[i] = VK_NULL_HANDLE;
        }
    }

    printf("[C-CORE] Async Threads joined, Devices idled, Ring Purged, "
           "and Pools/Fences destroyed.\n");
}
