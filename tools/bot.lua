require("runtime.boot.path_weaver")
-- scripts/bot.lua
io.stdout:setvbuf("no")

local ffi = require("ffi")

-- 1. BEDROCK TIMING SUBSYSTEM
ffi.cdef[[
void Sleep(uint32_t dwMilliseconds);
int usleep(uint32_t usec);
int QueryPerformanceCounter(int64_t *lpPerformanceCount);
int QueryPerformanceFrequency(int64_t *lpFrequency);
typedef struct { long tv_sec; long tv_nsec; } timespec;
int clock_gettime(int clk_id, timespec *tp);
]]

local function sys_sleep(ms)
    if jit.os == "Windows" then ffi.C.Sleep(ms) else ffi.C.usleep(ms * 1000) end
end

local get_time_hires
if jit.os == "Windows" then
    local freq = ffi.new("int64_t[1]")
    ffi.C.QueryPerformanceFrequency(freq)
    local inv_freq = 1.0 / tonumber(freq[0])
    get_time_hires = function()
        local count = ffi.new("int64_t[1]")
        ffi.C.QueryPerformanceCounter(count)
        return tonumber(count[0]) * inv_freq
    end
else
    local CLOCK_MONOTONIC = 1
    get_time_hires = function()
        local ts = ffi.new("timespec")
        ffi.C.clock_gettime(CLOCK_MONOTONIC, ts)
        return tonumber(ts.tv_sec) + (tonumber(ts.tv_nsec) * 1e-9)
    end
end

-- 2. SPARSE SIMULATION MEMORY
-- Dynamically load the exact same state definition and test pattern as the visual client
local cfg_sim = require("config_sim")
local app_ctx = { cfg_sim = cfg_sim }
local Game = require("game_state").init(app_ctx)

-- 3. THE BOT ORCHESTRATOR
local net_driver = require("netcode")

local function main()
    local local_port = tonumber(arg[1]) or 49200
    local target_lobby_id = arg[2]

    -- Allocate the 24KB state using the shared InitState function
    local state_ptr = Game.InitState()
    local state_size = Game.GetStateSize()

    -- Seed the random number generator using the port
    math.randomseed(os.time() + local_port)

    print(string.format("[BOT:%d] Booting Headless Chaos Node...", local_port))
    local net_engine = net_driver.init(local_port, target_lobby_id, state_ptr, state_size)

    local last_time = get_time_hires()
    local tick_count = 0

    while true do
        local current_time = get_time_hires()
        local frame_time = math.max(0.001, math.min(current_time - last_time, 0.25))
        last_time = current_time

        -- [INJECT CHAOS]
        -- Wait for 240 ticks (~4 seconds) before initiating the spam
        -- to allow the network lobby to fully stabilize and establish baselines.
        if tick_count > 0 then
            -- 20% chance per frame to randomly toggle a tile on the 256x256 grid.
            if math.random() > 0.0  then
                local random_idx = math.random(0, 65535)
                net_driver.inject_local_command(net_engine, 1, random_idx)
            end
        end

        -- Pump the network engine
        net_driver.pump_network(net_engine, frame_time)

        -- Periodic heartbeat logging to keep the terminal from drowning in prints
        tick_count = tick_count + 1
        if tick_count % 600 == 0 then
            print(string.format("[BOT:%d] Heartbeat - Sparse Mods Tracked: %d", local_port, state_ptr.modification_count))
        end

        -- Sleep to maintain roughly a 60Hz tick rate
        sys_sleep(16)
    end
end

main()
