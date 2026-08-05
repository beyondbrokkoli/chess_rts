/* host/ring_stream.c */

EXPORT void vx_sys_dump_ring_state(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return;
    uint32_t mask   = L_R(g_ring.locked_mask);
    int      ready  = L_R(g_ring.ready_idx[win_id]);
    int      local  = L_R(g_ring.local_read[win_id]);
    int      wsi    = L_R(g_wsi_state[win_id]);
    int      offset = win_id * 4;
    uint32_t tenant_mask = (mask >> offset) & 0xF;

    printf("\n--- FREEZE AUTOPSY (Tenant %d) ---\n", win_id);
    printf("WSI State  : %d\n", wsi);
    printf("Ready Idx  : %d\n", ready);
    printf("Local Read : %d\n", local);
    printf("Slot Locks : [ %d | %d | %d | %d ]\n",
           (tenant_mask & 1) != 0, (tenant_mask & 2) != 0,
           (tenant_mask & 4) != 0, (tenant_mask & 8) != 0);
    printf("----------------------------------\n");
    fflush(stdout);
}

EXPORT RenderPacket* vx_stream_packet(int idx) {
    if (idx < 0 || idx >= RING_SIZE) {
        printf("[FATAL] -1 index requests");
        return NULL;
    }
    return &g_ring.packets[idx];
}

EXPORT int vx_stream_acquire(int win_id) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return -1;
    int ready  = L(g_ring.ready_idx[win_id]);
    int offset = win_id * 4;

    for (int i = 1; i <= 4; i++) {
        int local_curr = (ready == -1) ? -1 : (ready - offset);
        int next_local = (local_curr + i) % 4;
        int global_idx = offset + next_local;
        uint32_t bit   = (1u << global_idx);
        uint32_t expected = L(g_ring.locked_mask);

        while ((expected & bit) == 0) {
            if (CWX(g_ring.locked_mask, expected, expected | bit)) return global_idx;
        }
    }
    return -1;
}

EXPORT void vx_stream_commit(int win_id, int idx) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return;
    atomic_thread_fence(memory_order_release);
    S(g_ring.ready_idx[win_id], idx);
}

EXPORT void vx_stream_init(int win_id, RenderThreadInit* wsi) {
    if (win_id < 0 || win_id >= MAX_WINDOWS) return;
    S(g_wsi_state[win_id], 0);
    int timeout = 2000;
    int spin_count = 0;

    while (L(g_render_busy[win_id]) || L(g_transfer_busy[win_id])) {
        if (spin_count >= 2000) { timeout--; }
        if (timeout <= 0) {
            printf("[C-FATAL] Threads failed to release busy flags "
                   "for Tenant %d. Aborting init to prevent corruption.\n", win_id);
            return;
        }
        vx_spin_wait(&spin_count);
    }

    g_window_wsi[win_id] = *wsi;
    int      offset      = win_id * 4;
    uint32_t tenant_mask = 0xFu << offset;
    FA(g_ring.locked_mask, ~tenant_mask);

    S(g_ring.ready_idx[win_id],  -1);
    S(g_ring.local_read[win_id], -1);

    for (int f = 0; f < 10; f++) {
        g_ring.active_ring_slots[win_id][f] = -1;
    }
    S(g_wsi_state[win_id], 1);
}
