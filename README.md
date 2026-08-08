### DEMO ENGINE

Whether you are on Linux (`./launch.sh`) or Windows (`launch.bat`), the syntax is identical.

| Command | Syntax | Description |
| --- | --- | --- |
| **Host** | `host [size]` | Creates a new graphical host node. (Default size: 8) |
| **Client** | `client <lobby_id> [size]` | Joins an existing lobby as a graphical client. |
| **Attach** | `attach <bot_count> <lobby_id> [size]` | Injects headless chaos bots into an active lobby. |
| **Lab** | `lab` | Boots a full 8-player local test (4 graphical, 4 headless). |
| **Swarm** | `swarm [gui_count] [bot_count]` | Custom local cluster testing. |
| **Clean** | `clean` | Force-kills all running engine processes and frees sockets. |

```text
chess_rts/                                 │       ├── network.lua
├── .gitattributes                         │       └── vx_net.c
├── .gitignore                             ├── render/
├── bin/                                   │   ├── debug/
│   ├── boot.elf                           │   │   └── vk_debug.c
│   ├── boot.exe                           │   ├── gpu/
│   ├── boot_headless.elf                  │   │   ├── vk_draw.c
│   ├── boot_headless.exe                  │   │   ├── vk_record.c
│   ├── glfw3.dll                          │   │   └── vk_render_loop.c
│   ├── libvx_net.so                       │   ├── tenant/
│   ├── libwinpthread-1.dll                │   │   └── vk_tenant_alloc.c
│   ├── lua51.dll                          │   └── transfer/
│   ├── render_frag.spv                    │       ├── vk_transfer_api.c
│   ├── render_vert.spv                    │       └── vk_transfer_loop.c
│   └── vx_net.dll                         ├── runtime/
├── build/                                 │   ├── boot/
│   ├── ctx_build.lua                      │   │   ├── core_abi.lua
│   ├── export_c_hdr.lua                   │   │   ├── engine_api.lua
│   ├── export_glsl.lua                    │   │   ├── main.lua
│   ├── task_c_objects.lua                 │   │   ├── path_weaver.lua
│   ├── task_headless.lua                  │   │   ├── weaver_boot.lua
│   ├── task_invariants.lua                │   │   └── window_api.lua
│   └── task_shaders.lua                   │   ├── presentation/
├── docs/                                  │   │   ├── graphics/
│   ├── deps_c.md                          │   │   │   ├── compute_pipeline.lua
│   ├── deps_glsl.md                       │   │   │   ├── graphics_pipeline.lua
│   ├── deps_lua.md                        │   │   │   ├── renderer.lua
│   ├── repo_ascii.txt                     │   │   │   └── sequence.lua
│   └── repo_tree.md                       │   │   └── translation/
├── generated/                             │   │       ├── pipeline_manifest.lua
│   ├── registry.glsl                      │   │       └── render_queue.lua
│   ├── ssot_render.h                      │   ├── services/
│   └── ssot_types.h                       │   │   ├── gpu/
├── host/                                  │   │   │   ├── descriptors.lua
│   ├── boot/                              │   │   │   ├── registry_vk.lua
│   │   ├── lifecycle.c                    │   │   │   ├── swapchain.lua
│   │   ├── main.c                         │   │   │   ├── vulkan_core.lua
│   │   └── main_headless.c                │   │   │   └── weaver_vram.lua
│   ├── ipc/                               │   │   ├── math/
│   │   ├── mailbox.c                      │   │   │   ├── fixed_math.lua
│   │   ├── ring_stream.c                  │   │   │   └── vmath.lua
│   │   └── sys_sync.c                     │   │   ├── memory/
│   ├── lua/                               │   │   │   └── memory.lua
│   │   └── lua_vm.c                       │   │   └── tenants/
│   ├── runtime/                           │   │       ├── tenant_lifecycle.lua
│   │   └── main_loop.c                    │   │       └── tenant_registry.lua
│   ├── state/                             │   ├── shutdown/
│   │   ├── state_globals.c                │   │   └── teardown.lua
│   │   └── state_types.c                  │   └── simulation/
│   ├── tenant/                            │       ├── camera.lua
│   │   ├── tenant_callbacks.c             │       ├── game_state.lua
│   │   ├── tenant_callbacks_key.c         │       └── raycast.lua
│   │   ├── tenant_callbacks_mouse.c       ├── server/
│   │   ├── tenant_callbacks_state.c       │   ├── api.py
│   │   ├── tenant_input.c                 │   ├── matchmaker.py
│   │   └── tenant_sys.c                   │   ├── models.py
│   └── threading/                         │   ├── relay.py
│       ├── thread_lifecycle.c             │   └── state.py
│       └── thread_pool.c                  ├── shaders/
├── launch.bat                             │   ├── render.frag
├── launch.sh                              │   ├── render.vert
├── logs/                                  │   └── shared.glsl
├── network/                               ├── ssot/
│   ├── lockstep/                          │   ├── config_gfx.lua
│   │   ├── fsm_core.lua                   │   ├── config_sim.lua
│   │   ├── fsm_pacing.lua                 │   ├── ctx_types.lua
│   │   ├── fsm_simulator.lua              │   ├── registry.glsl
│   │   ├── history_buffer.lua             │   ├── type_math.lua
│   │   └── wire_codec.lua                 │   └── type_render.lua
│   ├── protocol/                          ├── tools/
│   │   ├── config_net.lua                 │   ├── ascii_tree_cols.py
│   │   ├── dkjson.lua                     │   ├── bot.lua
│   │   ├── json_util.lua                  │   ├── login_test.sh
│   │   ├── shared_structs.h               │   ├── trace_deps_c.py
│   │   └── structs.lua                    │   ├── trace_deps_glsl.py
│   ├── session/                           │   ├── trace_deps_lua.py
│   │   ├── net_utils.lua                  │   └── trace_tree.py
│   │   └── netcode.lua                    └── worlds/
│   └── transport/                             └── chess/
│       ├── net_pump.lua                           └── plugin.lua

```
