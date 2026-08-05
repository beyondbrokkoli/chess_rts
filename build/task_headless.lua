-- Replace your current build/task_headless.lua with this:

return function(ctx)
    print("[4/4] Compiling Headless Host (Unity Build)...")

    if ctx.platform == "linux" then
        local linux_build = "gcc host/main_headless.c -O3 -march=x86-64-v3 -Wl,-E -I/usr/include/luajit-2.1 -lluajit-5.1 -lm -lpthread -o bin/boot_headless.elf"

        if not ctx.run_cmd(linux_build) then
            print(" [WARNING] Headless host compilation failed.")
        else
            print(" |- Linux headless executable (boot_headless.elf) compiled.")
        end

    elseif ctx.platform == "win" then
        local LUA_INC = "C:/msys64/mingw64/include/luajit-2.1"

        -- Notice: No -lws2_32. The dynamic DLL handles that now.
        local win_build = string.format(
            'gcc host/main_headless.c -O3 -march=x86-64-v3 -Wl,--export-all-symbols,--no-insert-timestamp -I"%s" -lluajit-5.1 -lm -o bin/boot_headless.exe',
            LUA_INC
        )

        if not ctx.run_cmd(win_build) then
            print(" [WARNING] Windows headless compilation failed.")
        else
            print(" |- Windows headless executable (boot_headless.exe) compiled.")
        end
    end
end
