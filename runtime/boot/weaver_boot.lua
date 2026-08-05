-- staging/weaver_boot.lua
local Boot = {}

function Boot.run_sequence(seq_boot, WindowAPI, sys_sleep)
    print("[LUA IO] Booting Visual Weaver in strict linear mode...")

    local boot_ctx = { win_id = 0, old_swapchain = nil }

    local ok, err = pcall(function()
        for i, stage in ipairs(seq_boot) do
            print(string.format("[WEAVER] Executing Stage %d: %s", i, stage.name))
            local signal = stage.action(boot_ctx)

            if signal == "AWAIT_SURFACE" then
                print("[WEAVER] Blocking execution, waiting for C-Core Surface...")
                while WindowAPI.get_surface(boot_ctx.win_id) == nil do
                    sys_sleep(10)
                end
            end
        end
    end)

    if not ok then
        error("Fatal Weaver Crash: " .. tostring(err))
    end

    print("[LUA IO] Weaver sequence complete! Unpacking Context...")
    return boot_ctx
end

return Boot
