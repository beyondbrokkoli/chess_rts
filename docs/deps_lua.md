```mermaid
graph TD
    %% WeaverEngine Lua Dependencies
    subgraph build
        build_ctx_build_lua["build/ctx_build.lua"]
        build_export_c_hdr_lua["build/export_c_hdr.lua"]
        build_export_glsl_lua["build/export_glsl.lua"]
        build_task_c_objects_lua["build/task_c_objects.lua"]
        build_task_headless_lua["build/task_headless.lua"]
        build_task_invariants_lua["build/task_invariants.lua"]
        build_task_shaders_lua["build/task_shaders.lua"]
    end
    subgraph external
        bit["bit"]
        debug["debug"]
        ffi["ffi"]
        game["game"]
        lpeg["lpeg"]
        math["math"]
    end
    subgraph network
        network_lockstep_fsm_core_lua["network/lockstep/fsm_core.lua"]
        network_lockstep_fsm_pacing_lua["network/lockstep/fsm_pacing.lua"]
        network_lockstep_fsm_simulator_lua["network/lockstep/fsm_simulator.lua"]
        network_lockstep_history_buffer_lua["network/lockstep/history_buffer.lua"]
        network_lockstep_wire_codec_lua["network/lockstep/wire_codec.lua"]
        network_protocol_config_net_lua["network/protocol/config_net.lua"]
        network_protocol_dkjson_lua["network/protocol/dkjson.lua"]
        network_protocol_json_util_lua["network/protocol/json_util.lua"]
        network_protocol_structs_lua["network/protocol/structs.lua"]
        network_session_net_utils_lua["network/session/net_utils.lua"]
        network_session_netcode_lua["network/session/netcode.lua"]
        network_transport_net_pump_lua["network/transport/net_pump.lua"]
        network_transport_network_lua["network/transport/network.lua"]
    end
    subgraph runtime
        runtime_boot_core_abi_lua["runtime/boot/core_abi.lua"]
        runtime_boot_engine_api_lua["runtime/boot/engine_api.lua"]
        runtime_boot_main_lua["runtime/boot/main.lua"]
        runtime_boot_path_weaver_lua["runtime/boot/path_weaver.lua"]
        runtime_boot_weaver_boot_lua["runtime/boot/weaver_boot.lua"]
        runtime_boot_window_api_lua["runtime/boot/window_api.lua"]
        runtime_presentation_graphics_compute_pipeline_lua["runtime/presentation/graphics/compute_pipeline.lua"]
        runtime_presentation_graphics_graphics_pipeline_lua["runtime/presentation/graphics/graphics_pipeline.lua"]
        runtime_presentation_graphics_renderer_lua["runtime/presentation/graphics/renderer.lua"]
        runtime_presentation_graphics_sequence_lua["runtime/presentation/graphics/sequence.lua"]
        runtime_presentation_translation_pipeline_manifest_lua["runtime/presentation/translation/pipeline_manifest.lua"]
        runtime_presentation_translation_render_queue_lua["runtime/presentation/translation/render_queue.lua"]
        runtime_services_gpu_descriptors_lua["runtime/services/gpu/descriptors.lua"]
        runtime_services_gpu_registry_vk_lua["runtime/services/gpu/registry_vk.lua"]
        runtime_services_gpu_swapchain_lua["runtime/services/gpu/swapchain.lua"]
        runtime_services_gpu_vulkan_core_lua["runtime/services/gpu/vulkan_core.lua"]
        runtime_services_gpu_vulkan_headers_lua["runtime/services/gpu/vulkan_headers.lua"]
        runtime_services_gpu_weaver_vram_lua["runtime/services/gpu/weaver_vram.lua"]
        runtime_services_math_fixed_math_lua["runtime/services/math/fixed_math.lua"]
        runtime_services_math_vmath_lua["runtime/services/math/vmath.lua"]
        runtime_services_memory_memory_lua["runtime/services/memory/memory.lua"]
        runtime_services_tenants_tenant_lifecycle_lua["runtime/services/tenants/tenant_lifecycle.lua"]
        runtime_services_tenants_tenant_registry_lua["runtime/services/tenants/tenant_registry.lua"]
        runtime_shutdown_teardown_lua["runtime/shutdown/teardown.lua"]
        runtime_simulation_camera_lua["runtime/simulation/camera.lua"]
        runtime_simulation_game_state_lua["runtime/simulation/game_state.lua"]
        runtime_simulation_raycast_lua["runtime/simulation/raycast.lua"]
    end
    subgraph ssot
        ssot_config_gfx_lua["ssot/config_gfx.lua"]
        ssot_config_sim_lua["ssot/config_sim.lua"]
        ssot_ctx_types_lua["ssot/ctx_types.lua"]
        ssot_type_math_lua["ssot/type_math.lua"]
        ssot_type_render_lua["ssot/type_render.lua"]
    end
    subgraph tools
        tools_bot_lua["tools/bot.lua"]
        tools_minify_lua["tools/minify.lua"]
        tools_seam_tracer_lua["tools/seam_tracer.lua"]
    end
    subgraph worlds
        worlds_chess_commands_input_lua["worlds/chess/commands/input.lua"]
        worlds_chess_frontend_colors_lua["worlds/chess/frontend/colors.lua"]
        worlds_chess_frontend_conf_lua["worlds/chess/frontend/conf.lua"]
        worlds_chess_frontend_graphics_lua["worlds/chess/frontend/graphics.lua"]
        worlds_chess_frontend_interface_lua["worlds/chess/frontend/interface.lua"]
        worlds_chess_frontend_luachess_main_lua["worlds/chess/frontend/luachess_main.lua"]
        worlds_chess_frontend_piecemap_lua["worlds/chess/frontend/piecemap.lua"]
        worlds_chess_plugin_lua["worlds/chess/plugin.lua"]
        worlds_chess_rules_attack_lua["worlds/chess/rules/attack.lua"]
        worlds_chess_rules_logic_lua["worlds/chess/rules/logic.lua"]
        worlds_chess_rules_move_lua["worlds/chess/rules/move.lua"]
        worlds_chess_rules_standard_lua["worlds/chess/rules/standard.lua"]
        worlds_chess_rules_turn_lua["worlds/chess/rules/turn.lua"]
        worlds_chess_state_board_lua["worlds/chess/state/board.lua"]
        worlds_chess_state_global_lua["worlds/chess/state/global.lua"]
    end
    build_ctx_build_lua --> build_export_c_hdr_lua
    build_ctx_build_lua --> build_export_glsl_lua
    build_ctx_build_lua --> build_task_c_objects_lua
    build_ctx_build_lua --> build_task_headless_lua
    build_ctx_build_lua --> build_task_invariants_lua
    build_ctx_build_lua --> build_task_shaders_lua
    build_ctx_build_lua --> ffi
    build_ctx_build_lua --> ssot_config_gfx_lua
    build_ctx_build_lua --> ssot_config_sim_lua
    build_ctx_build_lua --> ssot_ctx_types_lua
    network_lockstep_fsm_core_lua --> bit
    network_lockstep_fsm_core_lua --> ffi
    network_lockstep_fsm_core_lua --> network_lockstep_fsm_pacing_lua
    network_lockstep_fsm_core_lua --> network_lockstep_fsm_simulator_lua
    network_lockstep_fsm_simulator_lua --> bit
    network_lockstep_fsm_simulator_lua --> ffi
    network_lockstep_fsm_simulator_lua --> network_protocol_structs_lua
    network_lockstep_history_buffer_lua --> bit
    network_lockstep_history_buffer_lua --> ffi
    network_lockstep_wire_codec_lua --> bit
    network_lockstep_wire_codec_lua --> ffi
    network_protocol_config_net_lua --> ffi
    network_protocol_config_net_lua --> network_protocol_structs_lua
    network_protocol_dkjson_lua --> debug
    network_protocol_dkjson_lua --> lpeg
    network_protocol_json_util_lua --> network_protocol_dkjson_lua
    network_protocol_structs_lua --> ffi
    network_session_net_utils_lua --> ffi
    network_session_net_utils_lua --> network_protocol_config_net_lua
    network_session_net_utils_lua --> network_protocol_json_util_lua
    network_session_net_utils_lua --> network_transport_network_lua
    network_session_netcode_lua --> ffi
    network_session_netcode_lua --> network_lockstep_fsm_core_lua
    network_session_netcode_lua --> network_protocol_config_net_lua
    network_session_netcode_lua --> network_protocol_structs_lua
    network_session_netcode_lua --> network_session_net_utils_lua
    network_session_netcode_lua --> network_transport_net_pump_lua
    network_session_netcode_lua --> network_transport_network_lua
    network_session_netcode_lua --> runtime_boot_path_weaver_lua
    network_session_netcode_lua --> worlds_chess_plugin_lua
    network_transport_net_pump_lua --> ffi
    network_transport_net_pump_lua --> network_lockstep_history_buffer_lua
    network_transport_net_pump_lua --> network_lockstep_wire_codec_lua
    network_transport_net_pump_lua --> network_transport_network_lua
    network_transport_network_lua --> ffi
    runtime_boot_core_abi_lua --> ffi
    runtime_boot_engine_api_lua --> ffi
    runtime_boot_main_lua --> ffi
    runtime_boot_main_lua --> math
    runtime_boot_main_lua --> network_session_netcode_lua
    runtime_boot_main_lua --> runtime_boot_core_abi_lua
    runtime_boot_main_lua --> runtime_boot_engine_api_lua
    runtime_boot_main_lua --> runtime_boot_path_weaver_lua
    runtime_boot_main_lua --> runtime_boot_weaver_boot_lua
    runtime_boot_main_lua --> runtime_boot_window_api_lua
    runtime_boot_main_lua --> runtime_presentation_graphics_graphics_pipeline_lua
    runtime_boot_main_lua --> runtime_presentation_graphics_sequence_lua
    runtime_boot_main_lua --> runtime_presentation_translation_pipeline_manifest_lua
    runtime_boot_main_lua --> runtime_presentation_translation_render_queue_lua
    runtime_boot_main_lua --> runtime_services_gpu_weaver_vram_lua
    runtime_boot_main_lua --> runtime_services_math_fixed_math_lua
    runtime_boot_main_lua --> runtime_services_math_vmath_lua
    runtime_boot_main_lua --> runtime_services_memory_memory_lua
    runtime_boot_main_lua --> runtime_services_tenants_tenant_lifecycle_lua
    runtime_boot_main_lua --> runtime_services_tenants_tenant_registry_lua
    runtime_boot_main_lua --> runtime_shutdown_teardown_lua
    runtime_boot_main_lua --> runtime_simulation_camera_lua
    runtime_boot_main_lua --> runtime_simulation_game_state_lua
    runtime_boot_main_lua --> runtime_simulation_raycast_lua
    runtime_boot_main_lua --> ssot_config_gfx_lua
    runtime_boot_main_lua --> ssot_config_sim_lua
    runtime_boot_main_lua --> ssot_ctx_types_lua
    runtime_boot_main_lua --> ssot_type_math_lua
    runtime_boot_main_lua --> ssot_type_render_lua
    runtime_boot_window_api_lua --> ffi
    runtime_presentation_graphics_compute_pipeline_lua --> ffi
    runtime_presentation_graphics_compute_pipeline_lua --> runtime_services_gpu_registry_vk_lua
    runtime_presentation_graphics_graphics_pipeline_lua --> bit
    runtime_presentation_graphics_graphics_pipeline_lua --> ffi
    runtime_presentation_graphics_graphics_pipeline_lua --> runtime_services_gpu_registry_vk_lua
    runtime_presentation_graphics_renderer_lua --> ffi
    runtime_presentation_graphics_renderer_lua --> runtime_services_gpu_registry_vk_lua
    runtime_presentation_graphics_sequence_lua --> ffi
    runtime_presentation_graphics_sequence_lua --> runtime_boot_engine_api_lua
    runtime_presentation_graphics_sequence_lua --> runtime_boot_window_api_lua
    runtime_presentation_graphics_sequence_lua --> runtime_presentation_graphics_compute_pipeline_lua
    runtime_presentation_graphics_sequence_lua --> runtime_presentation_translation_pipeline_manifest_lua
    runtime_presentation_graphics_sequence_lua --> runtime_services_gpu_descriptors_lua
    runtime_presentation_graphics_sequence_lua --> runtime_services_gpu_registry_vk_lua
    runtime_presentation_graphics_sequence_lua --> runtime_services_gpu_vulkan_core_lua
    runtime_presentation_graphics_sequence_lua --> runtime_services_memory_memory_lua
    runtime_presentation_graphics_sequence_lua --> ssot_config_gfx_lua
    runtime_presentation_graphics_sequence_lua --> ssot_config_sim_lua
    runtime_presentation_translation_render_queue_lua --> bit
    runtime_presentation_translation_render_queue_lua --> ffi
    runtime_presentation_translation_render_queue_lua --> runtime_boot_engine_api_lua
    runtime_presentation_translation_render_queue_lua --> runtime_presentation_translation_pipeline_manifest_lua
    runtime_presentation_translation_render_queue_lua --> runtime_services_math_fixed_math_lua
    runtime_presentation_translation_render_queue_lua --> ssot_config_gfx_lua
    runtime_services_gpu_descriptors_lua --> bit
    runtime_services_gpu_descriptors_lua --> ffi
    runtime_services_gpu_descriptors_lua --> runtime_services_gpu_registry_vk_lua
    runtime_services_gpu_registry_vk_lua --> ffi
    runtime_services_gpu_registry_vk_lua --> runtime_services_gpu_vulkan_headers_lua
    runtime_services_gpu_swapchain_lua --> ffi
    runtime_services_gpu_swapchain_lua --> runtime_services_gpu_registry_vk_lua
    runtime_services_gpu_vulkan_core_lua --> bit
    runtime_services_gpu_vulkan_core_lua --> ffi
    runtime_services_gpu_vulkan_core_lua --> runtime_boot_engine_api_lua
    runtime_services_gpu_vulkan_core_lua --> runtime_services_gpu_registry_vk_lua
    runtime_services_gpu_vulkan_core_lua --> runtime_services_gpu_vulkan_headers_lua
    runtime_services_gpu_vulkan_headers_lua --> ffi
    runtime_services_gpu_weaver_vram_lua --> ffi
    runtime_services_math_vmath_lua --> ffi
    runtime_services_math_vmath_lua --> math
    runtime_services_memory_memory_lua --> bit
    runtime_services_memory_memory_lua --> ffi
    runtime_services_memory_memory_lua --> runtime_services_gpu_registry_vk_lua
    runtime_services_tenants_tenant_lifecycle_lua --> ffi
    runtime_services_tenants_tenant_lifecycle_lua --> runtime_presentation_graphics_graphics_pipeline_lua
    runtime_services_tenants_tenant_lifecycle_lua --> runtime_presentation_graphics_renderer_lua
    runtime_services_tenants_tenant_lifecycle_lua --> runtime_services_gpu_swapchain_lua
    runtime_services_tenants_tenant_registry_lua --> ffi
    runtime_services_tenants_tenant_registry_lua --> runtime_boot_engine_api_lua
    runtime_services_tenants_tenant_registry_lua --> runtime_boot_window_api_lua
    runtime_services_tenants_tenant_registry_lua --> runtime_presentation_graphics_renderer_lua
    runtime_services_tenants_tenant_registry_lua --> runtime_services_gpu_swapchain_lua
    runtime_services_tenants_tenant_registry_lua --> runtime_simulation_camera_lua
    runtime_shutdown_teardown_lua --> ffi
    runtime_shutdown_teardown_lua --> network_transport_network_lua
    runtime_shutdown_teardown_lua --> runtime_presentation_graphics_compute_pipeline_lua
    runtime_shutdown_teardown_lua --> runtime_presentation_graphics_graphics_pipeline_lua
    runtime_shutdown_teardown_lua --> runtime_presentation_graphics_renderer_lua
    runtime_shutdown_teardown_lua --> runtime_services_gpu_descriptors_lua
    runtime_shutdown_teardown_lua --> runtime_services_gpu_swapchain_lua
    runtime_shutdown_teardown_lua --> runtime_services_gpu_vulkan_core_lua
    runtime_simulation_camera_lua --> bit
    runtime_simulation_camera_lua --> ffi
    runtime_simulation_camera_lua --> math
    runtime_simulation_camera_lua --> runtime_boot_window_api_lua
    runtime_simulation_camera_lua --> runtime_services_math_vmath_lua
    runtime_simulation_game_state_lua --> ffi
    runtime_simulation_game_state_lua --> runtime_services_math_fixed_math_lua
    runtime_simulation_raycast_lua --> ffi
    runtime_simulation_raycast_lua --> runtime_services_math_fixed_math_lua
    runtime_simulation_raycast_lua --> runtime_services_math_vmath_lua
    runtime_simulation_raycast_lua --> ssot_config_sim_lua
    ssot_ctx_types_lua --> ffi
    ssot_ctx_types_lua --> ssot_type_math_lua
    ssot_ctx_types_lua --> ssot_type_render_lua
    tools_bot_lua --> ffi
    tools_bot_lua --> network_session_netcode_lua
    tools_bot_lua --> runtime_boot_path_weaver_lua
    tools_bot_lua --> runtime_simulation_game_state_lua
    tools_bot_lua --> ssot_config_sim_lua
    worlds_chess_commands_input_lua --> worlds_chess_state_global_lua
    worlds_chess_frontend_graphics_lua --> worlds_chess_state_global_lua
    worlds_chess_frontend_luachess_main_lua --> game
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_commands_input_lua
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_frontend_colors_lua
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_frontend_interface_lua
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_rules_standard_lua
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_state_board_lua
    worlds_chess_frontend_luachess_main_lua --> worlds_chess_state_global_lua
    worlds_chess_frontend_piecemap_lua --> worlds_chess_state_global_lua
    worlds_chess_plugin_lua --> ffi
    worlds_chess_plugin_lua --> network_transport_network_lua
    worlds_chess_plugin_lua --> runtime_services_math_fixed_math_lua
    worlds_chess_rules_logic_lua --> worlds_chess_rules_attack_lua
    worlds_chess_rules_logic_lua --> worlds_chess_rules_move_lua
    worlds_chess_rules_logic_lua --> worlds_chess_state_global_lua
    worlds_chess_rules_move_lua --> worlds_chess_state_global_lua
    worlds_chess_rules_standard_lua --> worlds_chess_state_global_lua
    worlds_chess_rules_turn_lua --> worlds_chess_rules_logic_lua
    worlds_chess_rules_turn_lua --> worlds_chess_state_global_lua
    worlds_chess_state_board_lua --> worlds_chess_frontend_graphics_lua
    worlds_chess_state_board_lua --> worlds_chess_frontend_piecemap_lua
    worlds_chess_state_board_lua --> worlds_chess_state_global_lua
```
