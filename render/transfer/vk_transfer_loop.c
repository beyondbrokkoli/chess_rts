/* render/vk_transfer_loop.c */

THREAD_FUNC transfer_thread_loop(void* arg) {
    printf("[C-CORE] Async Transfer Overlord Online.\n");

    while (L(g_transfer_thread_active) && L(g_engine.mailbox.is_running)) {
        bool worked = false;
        for (int i = 0; i < TRANSFER_RING_SIZE; i++) {
            if (L(g_transfer_ring[i].status) == 2) {
                TransferJob* job = &g_transfer_ring[i];
                int wid = job->target_window_id;

                S(g_transfer_busy[wid], 1);

                if (wid < 0 || wid >= MAX_WINDOWS || L(g_wsi_state[wid]) == 0) {
                    S(job->status, 0);
                    S(g_transfer_busy[wid], 0);
                    continue;
                }

                RenderThreadInit* wsi = &g_window_wsi[wid];
                if (!wsi->device || g_transfer_cmd_pools[wid] == VK_NULL_HANDLE) {
                    S(job->status, 0);
                    S(g_transfer_busy[wid], 0);
                    continue;
                }

                VkCommandBuffer cmd   = g_transfer_cmd_buffers[wid];
                VkFence         fence = g_transfer_fences[wid];

                PFN_vkWaitForFences pfnWait   = (PFN_vkWaitForFences)wsi->vkWaitForFences;
                PFN_vkResetFences   pfnReset  = (PFN_vkResetFences)wsi->vkResetFences;
                PFN_vkQueueSubmit   pfnSubmit = (PFN_vkQueueSubmit)wsi->vkQueueSubmit;

                VkResult res = pfnWait(wsi->device, 1, &fence, VK_TRUE, 2000000000);
                if (res == VK_TIMEOUT) {
                    printf("[C-FATAL] Tenant %d: GPU Transfer Hang detected!\n", wid);
                    S(job->status, 0);
                    S(g_wsi_state[wid], 0);
                    S(g_transfer_busy[wid], 0);
                    break;
                }

                pfnReset(wsi->device, 1, &fence);
                vkResetCommandBuffer(cmd, 0);

                VkCommandBufferBeginInfo beginInfo = {
                    .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO
                };
                vkBeginCommandBuffer(cmd, &beginInfo);

                VkBufferCopy copyRegion = {
                    .srcOffset = 0, .dstOffset = 0, .size = job->size
                };
                vkCmdCopyBuffer(cmd, (VkBuffer)job->src_buffer,
                                (VkBuffer)job->dst_buffer, 1, &copyRegion);
                vkEndCommandBuffer(cmd);

                VkSemaphore safe_timeline_semaphore =
                    (VkSemaphore)(uintptr_t)job->timeline_sem;

                VkTimelineSemaphoreSubmitInfo timelineInfo = {
                    .sType                  = 1000207003,
                    .signalSemaphoreValueCount = 1,
                    .pSignalSemaphoreValues = &job->signal_val
                };

                VkSubmitInfo submitInfo = {
                    .sType                = VK_STRUCTURE_TYPE_SUBMIT_INFO,
                    .pNext                = &timelineInfo,
                    .commandBufferCount   = 1,
                    .pCommandBuffers      = &cmd,
                    .signalSemaphoreCount = 1,
                    .pSignalSemaphores    = &safe_timeline_semaphore
                };

                pfnSubmit(wsi->transfer_queue, 1, &submitInfo, fence);
                pfnWait(wsi->device, 1, &fence, VK_TRUE, 2000000000);

                S(job->status, 0);
                S(g_transfer_busy[wid], 0);
                worked = true;
            }
        }
        if (!worked) SLEEP_MS(1);
    }
    printf("[C-CORE] Async Transfer Thread gracefully terminated.\n");
    return NULL;
}
