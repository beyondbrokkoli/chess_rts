/* render/vk_transfer_api.c */

EXPORT void vx_transfer_setup(void) {
    for (int i = 0; i < TRANSFER_RING_SIZE; i++) {
        atomic_init(&g_transfer_ring[i].status, 0);
    }
}

EXPORT int vx_transfer_request(int win_id, uint64_t src, uint64_t dst,
                               uint64_t size, uint64_t t_sem,
                               uint64_t sig_val) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return 0;

    for (int i = 0; i < TRANSFER_RING_SIZE; i++) {
        int expected = 0;
        if (CXS(g_transfer_ring[i].status, expected, 1)) {
            g_transfer_ring[i].src_buffer       = src;
            g_transfer_ring[i].dst_buffer       = dst;
            g_transfer_ring[i].size             = size;
            g_transfer_ring[i].timeline_sem     = t_sem;
            g_transfer_ring[i].signal_val       = sig_val;
            g_transfer_ring[i].target_window_id = win_id;
            S(g_transfer_ring[i].status, 2);
            return 1;
        }
    }
    return 0;
}
