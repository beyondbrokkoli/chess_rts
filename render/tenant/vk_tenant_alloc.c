/* render/vk_tenant_alloc.c */

EXPORT void vx_stream_allocate_tenant(int wid, RenderThreadInit* wsi,
                                      uint32_t gfx_family,
                                      uint32_t transfer_family) {
    if (wid < 0 || wid >= MAX_WINDOWS) {
        printf("[C-ERROR] Blocked out-of-bounds tenant allocation: %d\n", wid);
        return;
    }
    if (!wsi || !wsi->device) {
        printf("[C-ERROR] Failed to allocate tenant %d: Invalid WSI or Device.\n", wid);
        return;
    }

    if (g_render_cmd_pools[wid] == VK_NULL_HANDLE) {
        VkCommandPoolCreateInfo r_pool_info = {
            .sType            = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
            .flags            = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
            .queueFamilyIndex = gfx_family
        };
        vkCreateCommandPool(wsi->device, &r_pool_info, NULL, &g_render_cmd_pools[wid]);

        VkCommandBufferAllocateInfo r_alloc_info = {
            .sType              = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
            .commandPool        = g_render_cmd_pools[wid],
            .level              = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
            .commandBufferCount = 3
        };
        vkAllocateCommandBuffers(wsi->device, &r_alloc_info, g_render_cmd_buffers[wid]);
        printf("[C-CORE] Tenant %d: Render pool and 3x command buffers allocated.\n", wid);
    }

    if (g_transfer_cmd_pools[wid] == VK_NULL_HANDLE) {
        VkCommandPoolCreateInfo t_pool_info = {
            .sType            = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO,
            .flags            = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT,
            .queueFamilyIndex = transfer_family
        };
        vkCreateCommandPool(wsi->device, &t_pool_info, NULL, &g_transfer_cmd_pools[wid]);

        VkCommandBufferAllocateInfo t_alloc_info = {
            .sType              = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO,
            .commandPool        = g_transfer_cmd_pools[wid],
            .level              = VK_COMMAND_BUFFER_LEVEL_PRIMARY,
            .commandBufferCount = 1
        };
        vkAllocateCommandBuffers(wsi->device, &t_alloc_info, &g_transfer_cmd_buffers[wid]);

        VkFenceCreateInfo fence_info = {
            .sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO,
            .flags = 1
        };
        vkCreateFence(wsi->device, &fence_info, NULL, &g_transfer_fences[wid]);
        printf("[C-CORE] Tenant %d: Transfer pool, buffer, and fence allocated.\n", wid);
    }
}
