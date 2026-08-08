```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk", "nodeSpacing": 15, "rankSpacing": 45}}}%%
flowchart LR
    %% Directory Styling (Blue, Rounded)
    classDef dir fill:#1e293b,stroke:#3b82f6,stroke-width:2px,color:#f8fafc,rx:6,ry:6
    %% Standard File Styling (Green)
    classDef file fill:#0f172a,stroke:#10b981,stroke-width:1px,color:#cbd5e1
    %% Vendored/Generated File Styling (Amber, Dashed)
    classDef special fill:#0f172a,stroke:#f59e0b,stroke-width:1px,stroke-dasharray: 4 4,color:#94a3b8

    root["📁 chess_rts"]
    node_bin["📁 bin"]
    node_build["📁 build"]
    node_docs["📁 docs"]
    node_generated["📁 generated"]
    node_host["📁 host"]
    node_logs["📁 logs"]
    node_network["📁 network"]
    node_render["📁 render"]
    node_runtime["📁 runtime"]
    node_server["📁 server"]
    node_shaders["📁 shaders"]
    node_ssot["📁 ssot"]
    node_tools["📁 tools"]
    node_worlds["📁 worlds"]
    node__gitattributes["📄 .gitattributes"]
    node__gitignore["📄 .gitignore"]
    node_launch_bat["📄 launch.bat"]
    node_launch_sh["📄 launch.sh"]
    node_bin_boot_elf["📄 boot.elf"]
    node_bin_boot_exe["📄 boot.exe"]
    node_bin_boot_headless_elf["📄 boot_headless.elf"]
    node_bin_boot_headless_exe["📄 boot_headless.exe"]
    node_bin_glfw3_dll["📄 glfw3.dll"]
    node_bin_libvx_net_so["📄 libvx_net.so"]
    node_bin_libwinpthread_1_dll["📄 libwinpthread-1.dll"]
    node_bin_lua51_dll["📄 lua51.dll"]
    node_bin_render_frag_spv["📄 render_frag.spv"]
    node_bin_render_vert_spv["📄 render_vert.spv"]
    node_bin_vx_net_dll["📄 vx_net.dll"]
    node_build_ctx_build_lua["📄 ctx_build.lua"]
    node_build_export_c_hdr_lua["📄 export_c_hdr.lua"]
    node_build_export_glsl_lua["📄 export_glsl.lua"]
    node_build_task_c_objects_lua["📄 task_c_objects.lua"]
    node_build_task_headless_lua["📄 task_headless.lua"]
    node_build_task_invariants_lua["📄 task_invariants.lua"]
    node_build_task_shaders_lua["📄 task_shaders.lua"]
    node_ssot_config_gfx_lua["📄 config_gfx.lua"]
    node_ssot_config_sim_lua["📄 config_sim.lua"]
    node_ssot_ctx_types_lua["📄 ctx_types.lua"]
    node_ssot_registry_glsl["📄 registry.glsl"]
    node_ssot_type_math_lua["📄 type_math.lua"]
    node_ssot_type_render_lua["📄 type_render.lua"]
    node_shaders_render_frag["📄 render.frag"]
    node_shaders_render_vert["📄 render.vert"]
    node_shaders_shared_glsl["📄 shared.glsl"]
    node_worlds_chess["📁 chess"]
    node_worlds_chess_plugin_lua["📄 plugin.lua"]
    node_render_debug["📁 debug"]
    node_render_gpu["📁 gpu"]
    node_render_tenant["📁 tenant"]
    node_render_transfer["📁 transfer"]
    node_render_debug_vk_debug_c["📄 vk_debug.c"]
    node_render_tenant_vk_tenant_alloc_c["📄 vk_tenant_alloc.c"]
    node_render_transfer_vk_transfer_api_c["📄 vk_transfer_api.c"]
    node_render_transfer_vk_transfer_loop_c["📄 vk_transfer_loop.c"]
    node_render_gpu_vk_draw_c["📄 vk_draw.c"]
    node_render_gpu_vk_record_c["📄 vk_record.c"]
    node_render_gpu_vk_render_loop_c["📄 vk_render_loop.c"]
    node_generated_registry_glsl["📄 registry.glsl"]
    node_generated_ssot_render_h["📄 ssot_render.h"]
    node_generated_ssot_types_h["📄 ssot_types.h"]
    node_docs_deps_c_md["📄 deps_c.md"]
    node_docs_deps_glsl_md["📄 deps_glsl.md"]
    node_docs_deps_lua_md["📄 deps_lua.md"]
    node_runtime_boot["📁 boot"]
    node_runtime_presentation["📁 presentation"]
    node_runtime_services["📁 services"]
    node_runtime_shutdown["📁 shutdown"]
    node_runtime_simulation["📁 simulation"]
    node_runtime_simulation_camera_lua["📄 camera.lua"]
    node_runtime_simulation_game_state_lua["📄 game_state.lua"]
    node_runtime_simulation_raycast_lua["📄 raycast.lua"]
    node_runtime_boot_core_abi_lua["📄 core_abi.lua"]
    node_runtime_boot_engine_api_lua["📄 engine_api.lua"]
    node_runtime_boot_main_lua["📄 main.lua"]
    node_runtime_boot_path_weaver_lua["📄 path_weaver.lua"]
    node_runtime_boot_weaver_boot_lua["📄 weaver_boot.lua"]
    node_runtime_boot_window_api_lua["📄 window_api.lua"]
    node_runtime_shutdown_teardown_lua["📄 teardown.lua"]
    node_runtime_presentation_graphics["📁 graphics"]
    node_runtime_presentation_translation["📁 translation"]
    node_runtime_presentation_graphics_compute_pipeline_lua["📄 compute_pipeline.lua"]
    node_runtime_presentation_graphics_graphics_pipeline_lua["📄 graphics_pipeline.lua"]
    node_runtime_presentation_graphics_renderer_lua["📄 renderer.lua"]
    node_runtime_presentation_graphics_sequence_lua["📄 sequence.lua"]
    node_runtime_presentation_translation_pipeline_manifest_lua["📄 pipeline_manifest.lua"]
    node_runtime_presentation_translation_render_queue_lua["📄 render_queue.lua"]
    node_runtime_services_gpu["📁 gpu"]
    node_runtime_services_math["📁 math"]
    node_runtime_services_memory["📁 memory"]
    node_runtime_services_tenants["📁 tenants"]
    node_runtime_services_math_fixed_math_lua["📄 fixed_math.lua"]
    node_runtime_services_math_vmath_lua["📄 vmath.lua"]
    node_runtime_services_memory_memory_lua["📄 memory.lua"]
    node_runtime_services_tenants_tenant_lifecycle_lua["📄 tenant_lifecycle.lua"]
    node_runtime_services_tenants_tenant_registry_lua["📄 tenant_registry.lua"]
    node_runtime_services_gpu_descriptors_lua["📄 descriptors.lua"]
    node_runtime_services_gpu_registry_vk_lua["📄 registry_vk.lua"]
    node_runtime_services_gpu_swapchain_lua["📄 swapchain.lua"]
    node_runtime_services_gpu_vulkan_core_lua["📄 vulkan_core.lua"]
    node_runtime_services_gpu_weaver_vram_lua["📄 weaver_vram.lua"]
    node_network_lockstep["📁 lockstep"]
    node_network_protocol["📁 protocol"]
    node_network_session["📁 session"]
    node_network_transport["📁 transport"]
    node_network_lockstep_fsm_core_lua["📄 fsm_core.lua"]
    node_network_lockstep_fsm_pacing_lua["📄 fsm_pacing.lua"]
    node_network_lockstep_fsm_simulator_lua["📄 fsm_simulator.lua"]
    node_network_lockstep_history_buffer_lua["📄 history_buffer.lua"]
    node_network_lockstep_wire_codec_lua["📄 wire_codec.lua"]
    node_network_protocol_config_net_lua["📄 config_net.lua"]
    node_network_protocol_dkjson_lua["📄 dkjson.lua"]
    node_network_protocol_json_util_lua["📄 json_util.lua"]
    node_network_protocol_shared_structs_h["📄 shared_structs.h"]
    node_network_protocol_structs_lua["📄 structs.lua"]
    node_network_session_net_utils_lua["📄 net_utils.lua"]
    node_network_session_netcode_lua["📄 netcode.lua"]
    node_network_transport_net_pump_lua["📄 net_pump.lua"]
    node_network_transport_network_lua["📄 network.lua"]
    node_network_transport_vx_net_c["📄 vx_net.c"]
    node_tools_bot_lua["📄 bot.lua"]
    node_tools_login_test_sh["📄 login_test.sh"]
    node_tools_trace_deps_c_py["📄 trace_deps_c.py"]
    node_tools_trace_deps_glsl_py["📄 trace_deps_glsl.py"]
    node_tools_trace_deps_lua_py["📄 trace_deps_lua.py"]
    node_tools_trace_tree_py["📄 trace_tree.py"]
    node_server_api_py["📄 api.py"]
    node_server_matchmaker_py["📄 matchmaker.py"]
    node_server_models_py["📄 models.py"]
    node_server_relay_py["📄 relay.py"]
    node_server_state_py["📄 state.py"]
    node_host_boot["📁 boot"]
    node_host_ipc["📁 ipc"]
    node_host_lua["📁 lua"]
    node_host_runtime["📁 runtime"]
    node_host_state["📁 state"]
    node_host_tenant["📁 tenant"]
    node_host_threading["📁 threading"]
    node_host_state_state_globals_c["📄 state_globals.c"]
    node_host_state_state_types_c["📄 state_types.c"]
    node_host_boot_lifecycle_c["📄 lifecycle.c"]
    node_host_boot_main_c["📄 main.c"]
    node_host_boot_main_headless_c["📄 main_headless.c"]
    node_host_lua_lua_vm_c["📄 lua_vm.c"]
    node_host_threading_thread_lifecycle_c["📄 thread_lifecycle.c"]
    node_host_threading_thread_pool_c["📄 thread_pool.c"]
    node_host_tenant_tenant_callbacks_c["📄 tenant_callbacks.c"]
    node_host_tenant_tenant_callbacks_key_c["📄 tenant_callbacks_key.c"]
    node_host_tenant_tenant_callbacks_mouse_c["📄 tenant_callbacks_mouse.c"]
    node_host_tenant_tenant_callbacks_state_c["📄 tenant_callbacks_state.c"]
    node_host_tenant_tenant_input_c["📄 tenant_input.c"]
    node_host_tenant_tenant_sys_c["📄 tenant_sys.c"]
    node_host_ipc_mailbox_c["📄 mailbox.c"]
    node_host_ipc_ring_stream_c["📄 ring_stream.c"]
    node_host_ipc_sys_sync_c["📄 sys_sync.c"]
    node_host_runtime_main_loop_c["📄 main_loop.c"]

    root --> node_bin
    root --> node_build
    root --> node_docs
    root --> node_generated
    root --> node_host
    root --> node_logs
    root --> node_network
    root --> node_render
    root --> node_runtime
    root --> node_server
    root --> node_shaders
    root --> node_ssot
    root --> node_tools
    root --> node_worlds
    root --> node__gitattributes
    root --> node__gitignore
    root --> node_launch_bat
    root --> node_launch_sh
    node_bin --> node_bin_boot_elf
    node_bin --> node_bin_boot_exe
    node_bin --> node_bin_boot_headless_elf
    node_bin --> node_bin_boot_headless_exe
    node_bin --> node_bin_glfw3_dll
    node_bin --> node_bin_libvx_net_so
    node_bin --> node_bin_libwinpthread_1_dll
    node_bin --> node_bin_lua51_dll
    node_bin --> node_bin_render_frag_spv
    node_bin --> node_bin_render_vert_spv
    node_bin --> node_bin_vx_net_dll
    node_build --> node_build_ctx_build_lua
    node_build --> node_build_export_c_hdr_lua
    node_build --> node_build_export_glsl_lua
    node_build --> node_build_task_c_objects_lua
    node_build --> node_build_task_headless_lua
    node_build --> node_build_task_invariants_lua
    node_build --> node_build_task_shaders_lua
    node_ssot --> node_ssot_config_gfx_lua
    node_ssot --> node_ssot_config_sim_lua
    node_ssot --> node_ssot_ctx_types_lua
    node_ssot --> node_ssot_registry_glsl
    node_ssot --> node_ssot_type_math_lua
    node_ssot --> node_ssot_type_render_lua
    node_shaders --> node_shaders_render_frag
    node_shaders --> node_shaders_render_vert
    node_shaders --> node_shaders_shared_glsl
    node_worlds --> node_worlds_chess
    node_worlds_chess --> node_worlds_chess_plugin_lua
    node_render --> node_render_debug
    node_render --> node_render_gpu
    node_render --> node_render_tenant
    node_render --> node_render_transfer
    node_render_debug --> node_render_debug_vk_debug_c
    node_render_tenant --> node_render_tenant_vk_tenant_alloc_c
    node_render_transfer --> node_render_transfer_vk_transfer_api_c
    node_render_transfer --> node_render_transfer_vk_transfer_loop_c
    node_render_gpu --> node_render_gpu_vk_draw_c
    node_render_gpu --> node_render_gpu_vk_record_c
    node_render_gpu --> node_render_gpu_vk_render_loop_c
    node_generated --> node_generated_registry_glsl
    node_generated --> node_generated_ssot_render_h
    node_generated --> node_generated_ssot_types_h
    node_docs --> node_docs_deps_c_md
    node_docs --> node_docs_deps_glsl_md
    node_docs --> node_docs_deps_lua_md
    node_runtime --> node_runtime_boot
    node_runtime --> node_runtime_presentation
    node_runtime --> node_runtime_services
    node_runtime --> node_runtime_shutdown
    node_runtime --> node_runtime_simulation
    node_runtime_simulation --> node_runtime_simulation_camera_lua
    node_runtime_simulation --> node_runtime_simulation_game_state_lua
    node_runtime_simulation --> node_runtime_simulation_raycast_lua
    node_runtime_boot --> node_runtime_boot_core_abi_lua
    node_runtime_boot --> node_runtime_boot_engine_api_lua
    node_runtime_boot --> node_runtime_boot_main_lua
    node_runtime_boot --> node_runtime_boot_path_weaver_lua
    node_runtime_boot --> node_runtime_boot_weaver_boot_lua
    node_runtime_boot --> node_runtime_boot_window_api_lua
    node_runtime_shutdown --> node_runtime_shutdown_teardown_lua
    node_runtime_presentation --> node_runtime_presentation_graphics
    node_runtime_presentation --> node_runtime_presentation_translation
    node_runtime_presentation_graphics --> node_runtime_presentation_graphics_compute_pipeline_lua
    node_runtime_presentation_graphics --> node_runtime_presentation_graphics_graphics_pipeline_lua
    node_runtime_presentation_graphics --> node_runtime_presentation_graphics_renderer_lua
    node_runtime_presentation_graphics --> node_runtime_presentation_graphics_sequence_lua
    node_runtime_presentation_translation --> node_runtime_presentation_translation_pipeline_manifest_lua
    node_runtime_presentation_translation --> node_runtime_presentation_translation_render_queue_lua
    node_runtime_services --> node_runtime_services_gpu
    node_runtime_services --> node_runtime_services_math
    node_runtime_services --> node_runtime_services_memory
    node_runtime_services --> node_runtime_services_tenants
    node_runtime_services_math --> node_runtime_services_math_fixed_math_lua
    node_runtime_services_math --> node_runtime_services_math_vmath_lua
    node_runtime_services_memory --> node_runtime_services_memory_memory_lua
    node_runtime_services_tenants --> node_runtime_services_tenants_tenant_lifecycle_lua
    node_runtime_services_tenants --> node_runtime_services_tenants_tenant_registry_lua
    node_runtime_services_gpu --> node_runtime_services_gpu_descriptors_lua
    node_runtime_services_gpu --> node_runtime_services_gpu_registry_vk_lua
    node_runtime_services_gpu --> node_runtime_services_gpu_swapchain_lua
    node_runtime_services_gpu --> node_runtime_services_gpu_vulkan_core_lua
    node_runtime_services_gpu --> node_runtime_services_gpu_weaver_vram_lua
    node_network --> node_network_lockstep
    node_network --> node_network_protocol
    node_network --> node_network_session
    node_network --> node_network_transport
    node_network_lockstep --> node_network_lockstep_fsm_core_lua
    node_network_lockstep --> node_network_lockstep_fsm_pacing_lua
    node_network_lockstep --> node_network_lockstep_fsm_simulator_lua
    node_network_lockstep --> node_network_lockstep_history_buffer_lua
    node_network_lockstep --> node_network_lockstep_wire_codec_lua
    node_network_protocol --> node_network_protocol_config_net_lua
    node_network_protocol --> node_network_protocol_dkjson_lua
    node_network_protocol --> node_network_protocol_json_util_lua
    node_network_protocol --> node_network_protocol_shared_structs_h
    node_network_protocol --> node_network_protocol_structs_lua
    node_network_session --> node_network_session_net_utils_lua
    node_network_session --> node_network_session_netcode_lua
    node_network_transport --> node_network_transport_net_pump_lua
    node_network_transport --> node_network_transport_network_lua
    node_network_transport --> node_network_transport_vx_net_c
    node_tools --> node_tools_bot_lua
    node_tools --> node_tools_login_test_sh
    node_tools --> node_tools_trace_deps_c_py
    node_tools --> node_tools_trace_deps_glsl_py
    node_tools --> node_tools_trace_deps_lua_py
    node_tools --> node_tools_trace_tree_py
    node_server --> node_server_api_py
    node_server --> node_server_matchmaker_py
    node_server --> node_server_models_py
    node_server --> node_server_relay_py
    node_server --> node_server_state_py
    node_host --> node_host_boot
    node_host --> node_host_ipc
    node_host --> node_host_lua
    node_host --> node_host_runtime
    node_host --> node_host_state
    node_host --> node_host_tenant
    node_host --> node_host_threading
    node_host_state --> node_host_state_state_globals_c
    node_host_state --> node_host_state_state_types_c
    node_host_boot --> node_host_boot_lifecycle_c
    node_host_boot --> node_host_boot_main_c
    node_host_boot --> node_host_boot_main_headless_c
    node_host_lua --> node_host_lua_lua_vm_c
    node_host_threading --> node_host_threading_thread_lifecycle_c
    node_host_threading --> node_host_threading_thread_pool_c
    node_host_tenant --> node_host_tenant_tenant_callbacks_c
    node_host_tenant --> node_host_tenant_tenant_callbacks_key_c
    node_host_tenant --> node_host_tenant_tenant_callbacks_mouse_c
    node_host_tenant --> node_host_tenant_tenant_callbacks_state_c
    node_host_tenant --> node_host_tenant_tenant_input_c
    node_host_tenant --> node_host_tenant_tenant_sys_c
    node_host_ipc --> node_host_ipc_mailbox_c
    node_host_ipc --> node_host_ipc_ring_stream_c
    node_host_ipc --> node_host_ipc_sys_sync_c
    node_host_runtime --> node_host_runtime_main_loop_c

    class root dir
    class node_bin dir
    class node_build dir
    class node_docs dir
    class node_generated dir
    class node_host dir
    class node_logs dir
    class node_network dir
    class node_render dir
    class node_runtime dir
    class node_server dir
    class node_shaders dir
    class node_ssot dir
    class node_tools dir
    class node_worlds dir
    class node__gitattributes file
    class node__gitignore file
    class node_launch_bat file
    class node_launch_sh file
    class node_bin_boot_elf file
    class node_bin_boot_exe file
    class node_bin_boot_headless_elf file
    class node_bin_boot_headless_exe file
    class node_bin_glfw3_dll file
    class node_bin_libvx_net_so file
    class node_bin_libwinpthread_1_dll file
    class node_bin_lua51_dll file
    class node_bin_render_frag_spv file
    class node_bin_render_vert_spv file
    class node_bin_vx_net_dll file
    class node_build_ctx_build_lua file
    class node_build_export_c_hdr_lua file
    class node_build_export_glsl_lua file
    class node_build_task_c_objects_lua file
    class node_build_task_headless_lua file
    class node_build_task_invariants_lua file
    class node_build_task_shaders_lua file
    class node_ssot_config_gfx_lua file
    class node_ssot_config_sim_lua file
    class node_ssot_ctx_types_lua file
    class node_ssot_registry_glsl file
    class node_ssot_type_math_lua file
    class node_ssot_type_render_lua file
    class node_shaders_render_frag file
    class node_shaders_render_vert file
    class node_shaders_shared_glsl file
    class node_worlds_chess dir
    class node_worlds_chess_plugin_lua file
    class node_render_debug dir
    class node_render_gpu dir
    class node_render_tenant dir
    class node_render_transfer dir
    class node_render_debug_vk_debug_c file
    class node_render_tenant_vk_tenant_alloc_c file
    class node_render_transfer_vk_transfer_api_c file
    class node_render_transfer_vk_transfer_loop_c file
    class node_render_gpu_vk_draw_c file
    class node_render_gpu_vk_record_c file
    class node_render_gpu_vk_render_loop_c file
    class node_generated_registry_glsl file
    class node_generated_ssot_render_h file
    class node_generated_ssot_types_h file
    class node_docs_deps_c_md file
    class node_docs_deps_glsl_md file
    class node_docs_deps_lua_md file
    class node_runtime_boot dir
    class node_runtime_presentation dir
    class node_runtime_services dir
    class node_runtime_shutdown dir
    class node_runtime_simulation dir
    class node_runtime_simulation_camera_lua file
    class node_runtime_simulation_game_state_lua file
    class node_runtime_simulation_raycast_lua file
    class node_runtime_boot_core_abi_lua file
    class node_runtime_boot_engine_api_lua file
    class node_runtime_boot_main_lua file
    class node_runtime_boot_path_weaver_lua file
    class node_runtime_boot_weaver_boot_lua file
    class node_runtime_boot_window_api_lua file
    class node_runtime_shutdown_teardown_lua file
    class node_runtime_presentation_graphics dir
    class node_runtime_presentation_translation dir
    class node_runtime_presentation_graphics_compute_pipeline_lua file
    class node_runtime_presentation_graphics_graphics_pipeline_lua file
    class node_runtime_presentation_graphics_renderer_lua file
    class node_runtime_presentation_graphics_sequence_lua file
    class node_runtime_presentation_translation_pipeline_manifest_lua file
    class node_runtime_presentation_translation_render_queue_lua file
    class node_runtime_services_gpu dir
    class node_runtime_services_math dir
    class node_runtime_services_memory dir
    class node_runtime_services_tenants dir
    class node_runtime_services_math_fixed_math_lua file
    class node_runtime_services_math_vmath_lua file
    class node_runtime_services_memory_memory_lua file
    class node_runtime_services_tenants_tenant_lifecycle_lua file
    class node_runtime_services_tenants_tenant_registry_lua file
    class node_runtime_services_gpu_descriptors_lua file
    class node_runtime_services_gpu_registry_vk_lua file
    class node_runtime_services_gpu_swapchain_lua file
    class node_runtime_services_gpu_vulkan_core_lua file
    class node_runtime_services_gpu_weaver_vram_lua file
    class node_network_lockstep dir
    class node_network_protocol dir
    class node_network_session dir
    class node_network_transport dir
    class node_network_lockstep_fsm_core_lua file
    class node_network_lockstep_fsm_pacing_lua file
    class node_network_lockstep_fsm_simulator_lua file
    class node_network_lockstep_history_buffer_lua file
    class node_network_lockstep_wire_codec_lua file
    class node_network_protocol_config_net_lua file
    class node_network_protocol_dkjson_lua file
    class node_network_protocol_json_util_lua file
    class node_network_protocol_shared_structs_h file
    class node_network_protocol_structs_lua file
    class node_network_session_net_utils_lua file
    class node_network_session_netcode_lua file
    class node_network_transport_net_pump_lua file
    class node_network_transport_network_lua file
    class node_network_transport_vx_net_c file
    class node_tools_bot_lua file
    class node_tools_login_test_sh file
    class node_tools_trace_deps_c_py file
    class node_tools_trace_deps_glsl_py file
    class node_tools_trace_deps_lua_py file
    class node_tools_trace_tree_py file
    class node_server_api_py file
    class node_server_matchmaker_py file
    class node_server_models_py file
    class node_server_relay_py file
    class node_server_state_py file
    class node_host_boot dir
    class node_host_ipc dir
    class node_host_lua dir
    class node_host_runtime dir
    class node_host_state dir
    class node_host_tenant dir
    class node_host_threading dir
    class node_host_state_state_globals_c file
    class node_host_state_state_types_c file
    class node_host_boot_lifecycle_c file
    class node_host_boot_main_c file
    class node_host_boot_main_headless_c file
    class node_host_lua_lua_vm_c file
    class node_host_threading_thread_lifecycle_c file
    class node_host_threading_thread_pool_c file
    class node_host_tenant_tenant_callbacks_c file
    class node_host_tenant_tenant_callbacks_key_c file
    class node_host_tenant_tenant_callbacks_mouse_c file
    class node_host_tenant_tenant_callbacks_state_c file
    class node_host_tenant_tenant_input_c file
    class node_host_tenant_tenant_sys_c file
    class node_host_ipc_mailbox_c file
    class node_host_ipc_ring_stream_c file
    class node_host_ipc_sys_sync_c file
    class node_host_runtime_main_loop_c file
```
