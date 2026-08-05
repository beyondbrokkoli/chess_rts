# 1. Update the Pure Netcode includes
sed -i 's|#include "shared_structs.h"|#include "../protocol/shared_structs.h"|' network/transport/vx_net.c

# 2. Update the Headless Unity Build
sed -i 's|#include "sys_sync.c"|#include "../ipc/sys_sync.c"|' host/boot/main_headless.c
sed -i 's|"scripts/bot.lua"|"tools/bot.lua"|' host/boot/main_headless.c

# 3. Update the Main Host Unity Build
sed -i 's|"../gen/ssot_types.h"|"../../generated/ssot_types.h"|' host/boot/main.c
sed -i 's|"../gen/ssot_render.h"|"../../generated/ssot_render.h"|' host/boot/main.c
sed -i 's|"sys_sync.c"|"../ipc/sys_sync.c"|' host/boot/main.c
sed -i 's|"state_types.c"|"../state/state_types.c"|' host/boot/main.c
sed -i 's|"state_globals.c"|"../state/state_globals.c"|' host/boot/main.c
sed -i 's|"thread_pool.c"|"../threading/thread_pool.c"|' host/boot/main.c
sed -i 's|"mailbox.c"|"../ipc/mailbox.c"|' host/boot/main.c
sed -i 's|"ring_stream.c"|"../ipc/ring_stream.c"|' host/boot/main.c
sed -i 's|"../render/vk_debug.c"|"../../render/debug/vk_debug.c"|' host/boot/main.c
sed -i 's|"../render/vk_tenant_alloc.c"|"../../render/tenant/vk_tenant_alloc.c"|' host/boot/main.c
sed -i 's|"../render/vk_transfer_api.c"|"../../render/transfer/vk_transfer_api.c"|' host/boot/main.c
sed -i 's|"../render/vk_transfer_loop.c"|"../../render/transfer/vk_transfer_loop.c"|' host/boot/main.c
sed -i 's|"../render/vk_draw.c"|"../../render/gpu/vk_draw.c"|' host/boot/main.c
sed -i 's|"../render/vk_record.c"|"../../render/gpu/vk_record.c"|' host/boot/main.c
sed -i 's|"../render/vk_render_loop.c"|"../../render/gpu/vk_render_loop.c"|' host/boot/main.c
sed -i 's|"thread_lifecycle.c"|"../threading/thread_lifecycle.c"|' host/boot/main.c
sed -i 's|"lua_vm.c"|"../lua/lua_vm.c"|' host/boot/main.c
sed -i 's|"main_loop.c"|"../runtime/main_loop.c"|' host/boot/main.c
