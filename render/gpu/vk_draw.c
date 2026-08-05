/* render/vk_draw.c */

void vx_execute_draw_commands(VkCommandBuffer cmd, RenderPacket* p, DrawCommand* queue, uint32_t count, RenderThreadInit* win_wsi) {
    VkViewport viewport = {0.0f, 0.0f, (float)p->width, (float)p->height, 0.0f, 1.0f};
    VkRect2D scissor = { {0, 0}, {p->width, p->height} };
    vkCmdSetViewport(cmd, 0, 1, &viewport);
    vkCmdSetScissor(cmd, 0, 1, &scissor);

    if (count == 0 || !p->vertex_buffer || !p->index_buffer) {
        return;
    }

    VkDeviceSize offset = 0;
    VkBuffer vbo = (VkBuffer)p->vertex_buffer;
    vkCmdBindVertexBuffers(cmd, 0, 1, &vbo, &offset);
    vkCmdBindIndexBuffer(cmd, (VkBuffer)p->index_buffer, 0, VK_INDEX_TYPE_UINT32);

    PFN_vkCmdSetCullModeEXT pfnSetCullMode = (PFN_vkCmdSetCullModeEXT)win_wsi->pfnSetCullMode;
    PFN_vkCmdSetFrontFaceEXT pfnSetFrontFace = (PFN_vkCmdSetFrontFaceEXT)win_wsi->pfnSetFrontFace;
    PFN_vkCmdSetPrimitiveTopologyEXT pfnSetPrimTopology = (PFN_vkCmdSetPrimitiveTopologyEXT)win_wsi->pfnSetPrimitiveTopology;
    PFN_vkCmdSetDepthTestEnableEXT pfnSetDepthTest = (PFN_vkCmdSetDepthTestEnableEXT)win_wsi->pfnSetDepthTestEnable;
    PFN_vkCmdSetDepthWriteEnableEXT pfnSetDepthWrite = (PFN_vkCmdSetDepthWriteEnableEXT)win_wsi->pfnSetDepthWriteEnable;
    PFN_vkCmdSetDepthCompareOpEXT pfnSetDepthComp = (PFN_vkCmdSetDepthCompareOpEXT)win_wsi->pfnSetDepthCompareOp;

    uint64_t cur_pipe = 0, cur_desc = 0;
    uint32_t safe_count = count > 1024 ? 1024 : count;

    for (uint32_t i = 0; i < safe_count; i++) {
        DrawCommand* draw = &queue[i];

        if (draw->pipeline_id != cur_pipe) {
            vkCmdBindPipeline(cmd, VK_PIPELINE_BIND_POINT_GRAPHICS, (VkPipeline)draw->pipeline_id);
            cur_pipe = draw->pipeline_id;
        }
        if (draw->descriptor_set != cur_desc) {
            VkDescriptorSet dset = (VkDescriptorSet)draw->descriptor_set;
            vkCmdBindDescriptorSets(cmd, VK_PIPELINE_BIND_POINT_GRAPHICS, (VkPipelineLayout)p->gfx_layout, 0, 1, &dset, 0, NULL);
            cur_desc = draw->descriptor_set;
        }

        VkRect2D dyn_scissor = { { (int32_t)draw->scissor_x, (int32_t)draw->scissor_y }, { (uint32_t)draw->scissor_w, (uint32_t)draw->scissor_h } };
        vkCmdSetScissor(cmd, 0, 1, &dyn_scissor);

        pfnSetCullMode(cmd, draw->cull_mode);
        pfnSetFrontFace(cmd, draw->front_face);
        pfnSetPrimTopology(cmd, draw->topology);
        pfnSetDepthTest(cmd, draw->depth_test);
        pfnSetDepthWrite(cmd, draw->depth_write);
        pfnSetDepthComp(cmd, draw->depth_compare_op);

        vkCmdPushConstants(cmd, (VkPipelineLayout)p->gfx_layout, VK_SHADER_STAGE_VERTEX_BIT | VK_SHADER_STAGE_FRAGMENT_BIT, draw->pc_offset, draw->pc_size, draw->push_constants + draw->pc_offset);
        vkCmdDrawIndexed(cmd, draw->index_count, draw->instance_count, draw->first_index, draw->vertex_offset, draw->first_instance);
    }
}
