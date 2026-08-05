-- network/history_buffer.lua
local ffi = require("ffi")
local bit = require("bit")

local Buffer = {}

function Buffer.init(app_ctx)
    local RING_MASK = ffi.C.CFG_RING_SIZE - 1
    local LOCAL_HORIZON = app_ctx.cfg_net.LOCAL_HORIZON -- [CHANGED] Read local horizon
    local STATE_EMPTY = ffi.C.FRAME_STATE_EMPTY

    return {
        integrate = function(arena, commands_ptr, base_tick, history_count, pid, current_tick)
            -- [CHANGED] Window start is now bound by LOCAL_HORIZON (510 ticks), not wire history!
            local window_start = math.max(0, current_tick - LOCAL_HORIZON)
            local window_end = math.min(current_tick + RING_MASK, arena.confirmed_tick + RING_MASK)

            for h = 0, history_count - 1 do
                local h_tick = base_tick + h

                if h_tick > arena.confirmed_tick and h_tick >= window_start and h_tick <= window_end then
                    local h_idx = bit.band(h_tick, RING_MASK)
                    local h_frame = arena.frames[h_idx]

                    if h_frame.tick ~= h_tick then
                        h_frame.tick = h_tick
                        h_frame.state = STATE_EMPTY
                        ffi.fill(h_frame.commands, ffi.sizeof(h_frame.commands), 0)
                        h_frame.state_checksum = 0
                        h_frame.remote_checksum = 0
                    end

                    local inc_ptr = ffi.cast("uint64_t*", commands_ptr[h])
                    local h_ptr = ffi.cast("uint64_t*", h_frame.commands[pid])

                    if h_ptr[0] ~= inc_ptr[0] or h_ptr[1] ~= inc_ptr[1] then
                        if h_tick < current_tick then
                            if arena.is_rollback_active == 0 or h_tick < arena.rollback_target then
                                arena.is_rollback_active = 1
                                arena.rollback_target = h_tick
                            end
                        end
                        h_ptr[0] = inc_ptr[0]
                        h_ptr[1] = inc_ptr[1]
                    end
                end
            end
        end,

        audit_checksum = function(arena, checksum, checksum_tick, current_tick, desync_sweep)
            if checksum ~= 0 and checksum_tick >= math.max(0, arena.confirmed_tick - desync_sweep) and checksum_tick <= current_tick then
                local c_idx = bit.band(checksum_tick, RING_MASK)
                local c_frame = arena.frames[c_idx]
                if c_frame.tick == checksum_tick then
                    c_frame.remote_checksum = checksum
                end
            end
        end
    }
end

return Buffer
