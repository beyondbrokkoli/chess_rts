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
demo_engine/                               ├── rag/
├── .gitattributes                         │   ├── ask.py
├── .gitignore                             │   └── ingest_codebase.py
├── bin/                                   ├── render/
│   ├── boot.elf                           │   ├── debug/
│   ├── boot.exe                           │   │   └── vk_debug.c
│   ├── boot_headless.elf                  │   ├── gpu/
│   ├── boot_headless.exe                  │   │   ├── vk_draw.c
│   ├── glfw3.dll                          │   │   ├── vk_record.c
│   ├── libvx_net.so                       │   │   └── vk_render_loop.c
│   ├── libwinpthread-1.dll                │   ├── tenant/
│   ├── lua51.dll                          │   │   └── vk_tenant_alloc.c
│   ├── render_frag.spv                    │   └── transfer/
│   ├── render_vert.spv                    │       ├── vk_transfer_api.c
│   └── vx_net.dll                         │       └── vk_transfer_loop.c
├── build/                                 ├── runtime/
│   ├── ctx_build.lua                      │   ├── boot/
│   ├── export_c_hdr.lua                   │   │   ├── core_abi.lua
│   ├── export_glsl.lua                    │   │   ├── engine_api.lua
│   ├── task_c_objects.lua                 │   │   ├── main.lua
│   ├── task_headless.lua                  │   │   ├── path_weaver.lua
│   ├── task_invariants.lua                │   │   ├── weaver_boot.lua
│   └── task_shaders.lua                   │   │   └── window_api.lua
├── docs/                                  │   ├── presentation/
│   ├── deps_c.md                          │   │   ├── graphics/
│   ├── deps_glsl.md                       │   │   │   ├── compute_pipeline.lua
│   ├── deps_lua.md                        │   │   │   ├── graphics_pipeline.lua
│   ├── repo_ascii.txt                     │   │   │   ├── renderer.lua
│   └── repo_tree.md                       │   │   │   └── sequence.lua
├── generated/                             │   │   └── translation/
│   ├── registry.glsl                      │   │       ├── pipeline_manifest.lua
│   ├── ssot_render.h                      │   │       └── render_queue.lua
│   └── ssot_types.h                       │   ├── services/
├── host/                                  │   │   ├── gpu/
│   ├── boot/                              │   │   │   ├── descriptors.lua
│   │   ├── lifecycle.c                    │   │   │   ├── registry_vk.lua
│   │   ├── main.c                         │   │   │   ├── swapchain.lua
│   │   └── main_headless.c                │   │   │   ├── vulkan_core.lua
│   ├── ipc/                               │   │   │   └── weaver_vram.lua
│   │   ├── mailbox.c                      │   │   ├── math/
│   │   ├── ring_stream.c                  │   │   │   ├── fixed_math.lua
│   │   └── sys_sync.c                     │   │   │   └── vmath.lua
│   ├── lua/                               │   │   ├── memory/
│   │   └── lua_vm.c                       │   │   │   └── memory.lua
│   ├── runtime/                           │   │   └── tenants/
│   │   └── main_loop.c                    │   │       ├── tenant_lifecycle.lua
│   ├── state/                             │   │       └── tenant_registry.lua
│   │   ├── state_globals.c                │   ├── shutdown/
│   │   └── state_types.c                  │   │   └── teardown.lua
│   ├── tenant/                            │   └── simulation/
│   │   ├── tenant_callbacks.c             │       ├── camera.lua
│   │   ├── tenant_callbacks_key.c         │       ├── game_state.lua
│   │   ├── tenant_callbacks_mouse.c       │       └── raycast.lua
│   │   ├── tenant_callbacks_state.c       ├── server/
│   │   ├── tenant_input.c                 │   ├── api.py
│   │   └── tenant_sys.c                   │   ├── matchmaker.py
│   └── threading/                         │   ├── models.py
│       ├── thread_lifecycle.c             │   ├── relay.py
│       └── thread_pool.c                  │   └── state.py
├── launch.bat                             ├── shaders/
├── launch.sh                              │   ├── render.frag
├── network/                               │   ├── render.vert
│   ├── lockstep/                          │   └── shared.glsl
│   │   ├── fsm_core.lua                   ├── ssot/
│   │   ├── fsm_pacing.lua                 │   ├── config_gfx.lua
│   │   ├── fsm_simulator.lua              │   ├── config_sim.lua
│   │   ├── history_buffer.lua             │   ├── ctx_types.lua
│   │   └── wire_codec.lua                 │   ├── registry.glsl
│   ├── protocol/                          │   ├── type_math.lua
│   │   ├── config_net.lua                 │   └── type_render.lua
│   │   ├── dkjson.lua                     ├── tools/
│   │   ├── json_util.lua                  │   ├── ascii_tree_cols.py
│   │   ├── shared_structs.h               │   ├── bot.lua
│   │   └── structs.lua                    │   ├── login_test.sh
│   ├── session/                           │   ├── trace_deps_c.py
│   │   ├── net_utils.lua                  │   ├── trace_deps_glsl.py
│   │   └── netcode.lua                    │   ├── trace_deps_lua.py
│   └── transport/                         │   └── trace_tree.py
│       ├── net_pump.lua                   └── worlds/
│       ├── network.lua                        └── chess/
│       └── vx_net.c                               └── plugin.lua
├── parse_vk_xml.py

```
