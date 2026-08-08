-- launch.lua
local target = arg[1]
if target ~= "linux" and target ~= "win" then
    print("[FATAL] Usage: luajit launch.lua <linux|win>")
    os.exit(1)
end

local launcher = target == "linux" and "./launch.sh" or "launch.bat"

local function check_orphans()
    print("\n[ORPHANS] Scanning for active Weaver nodes...")
    local count = 0

    if target == "linux" then
        -- Use pgrep to find full command lines matching our binaries
        local f = io.popen("pgrep -a -f 'boot.*\\.elf'")
        if f then
            for line in f:lines() do
                print("  |- " .. line)
                count = count + 1
            end
            f:close()
        end
    else
        -- Use tasklist on Windows, filtering for our binaries
        local f = io.popen('tasklist 2>nul | findstr /I "boot.exe boot_headless.exe"')
        if f then
            for line in f:lines() do
                -- Strip excessive whitespace for a cleaner output
                print("  |- " .. line:gsub("%s+", " "))
                count = count + 1
            end
            f:close()
        end
    end

    if count == 0 then
        print("  |- No orphaned Weaver processes found. Clean slate.")
    else
        print("  |- Found " .. count .. " running node(s). (Type 'clean' to sweep them)")
    end
    print("")
end

print("=======================================================")
print(" Weaver CLI Orchestrator (Lua V1)")
print(" Platform: " .. string.upper(target))
print(" Commands: swarm, lab, host, client, attach")
print("           clean, orphans, exit")
print("=======================================================\n")

-- Main CLI Loop
while true do
    io.write("weaver> ")
    local input = io.read()

    -- Handle EOF (Ctrl+D / Ctrl+C)
    if not input then
        print("\n[CLI] EOF detected.")
        check_orphans()
        break
    end

    -- Parse input into arguments
    local args = {}
    for w in input:gmatch("%S+") do table.insert(args, w) end
    local cmd = args[1]

    if cmd == "exit" or cmd == "quit" then
        check_orphans()
        print("[CLI] Exiting Weaver Orchestrator. Goodbye!")
        break
    elseif cmd == "orphans" or cmd == "status" then
        check_orphans()
    elseif cmd == "clean" then
        print("[CLI] Issuing sweep command...")
        os.execute(launcher .. " clean")
    elseif cmd == "swarm" or cmd == "lab" or cmd == "host" or cmd == "client" or cmd == "attach" then
        -- Forward valid commands straight to the shell wrapper
        local full_cmd = launcher .. " " .. input
        print("[CLI] Executing: " .. full_cmd)
        os.execute(full_cmd)
    elseif cmd ~= nil and cmd ~= "" then
        print("[CLI] Unknown command: " .. cmd)
    end
end
