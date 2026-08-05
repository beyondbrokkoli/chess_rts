return function(ctx)
    print("[2/4] Compiling GLSL Shaders to SPIR-V...")
    local glslc = (ctx.platform == "win") and (ctx.vulkan_sdk_path .. "/Bin/glslc.exe") or "glslc"

    for _, sh in ipairs(ctx.shaders) do
        local cmd = string.format('%s %s -o %s', glslc, sh.src, sh.dst)
        if ctx.run_cmd(cmd) then
            print(" |- Compiled: " .. sh.dst)
        else
            print(" [ERROR] Failed to compile " .. sh.src .. " (Skipping...)")
        end
    end
    print(" |- Shader phase complete.\n")
end
