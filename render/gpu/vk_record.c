/* render/vk_record.c */

EXPORT void vx_record_commands(VkCommandBuffer cmd, RenderPacket* p, DrawCommand* queue, uint32_t count, RenderThreadInit* win_wsi) {
    if (!p->width || !p->height) return;

    VkCommandBufferBeginInfo beginInfo = { .sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO };
    vkBeginCommandBuffer(cmd, &beginInfo);

    /* ── Pre-pass barriers */
    VkImageMemoryBarrier preBarriers[2] = {
        { .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER, .oldLayout = VK_IMAGE_LAYOUT_UNDEFINED, .newLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, .image = (VkImage)p->swapchain_image, .subresourceRange = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1}, .dstAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT },
        { .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER, .oldLayout = VK_IMAGE_LAYOUT_UNDEFINED, .newLayout = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL, .image = (VkImage)p->depth_image, .subresourceRange = {VK_IMAGE_ASPECT_DEPTH_BIT, 0, 1, 0, 1}, .dstAccessMask = VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT }
    };
    vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT, 0, 0, NULL, 0, NULL, 2, preBarriers);

    /* ── Dynamic Rendering Begin */
    PFN_vkCmdBeginRenderingKHR pfnBegin = (PFN_vkCmdBeginRenderingKHR)win_wsi->pfnBegin;
    PFN_vkCmdEndRenderingKHR pfnEnd = (PFN_vkCmdEndRenderingKHR)win_wsi->pfnEnd;

    VkRenderingAttachmentInfoKHR colorAttachment = {
        .sType = VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR, .imageView = (VkImageView)p->swapchain_view, .imageLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, .loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR, .storeOp = VK_ATTACHMENT_STORE_OP_STORE, .clearValue = { .color = { .float32 = {0.01f, 0.01f, 0.02f, 1.0f} } }
    };
    VkRenderingAttachmentInfoKHR depthAttachment = {
        .sType = VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR, .imageView = (VkImageView)p->depth_view, .imageLayout = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL, .loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR, .storeOp = VK_ATTACHMENT_STORE_OP_STORE, .clearValue = { .depthStencil = {1.0f, 0} }
    };
    VkRenderingInfoKHR renderInfo = {
        .sType = VK_STRUCTURE_TYPE_RENDERING_INFO_KHR, .renderArea = { .extent = {p->width, p->height} }, .layerCount = 1, .colorAttachmentCount = 1, .pColorAttachments = &colorAttachment, .pDepthAttachment = &depthAttachment
    };
    pfnBegin(cmd, &renderInfo);

    /* ── Delegate the actual drawing ── */
    vx_execute_draw_commands(cmd, p, queue, count, win_wsi);

    /* ── Dynamic Rendering End */
    pfnEnd(cmd);

    /* ── Present barrier */
    VkImageMemoryBarrier presentBarrier = {
        .sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER, .oldLayout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL, .newLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR, .image = (VkImage)p->swapchain_image, .subresourceRange = {VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1}, .srcAccessMask = VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT, .dstAccessMask = 0
    };
    vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT, VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT, 0, 0, NULL, 0, NULL, 1, &presentBarrier);

    vkEndCommandBuffer(cmd);
}
