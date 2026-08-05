-- network/wire_codec.lua
local ffi = require("ffi")
local bit = require("bit")

local Codec = {}

function Codec.init(app_ctx)
    local RING_MASK = ffi.C.CFG_RING_SIZE - 1
    local HISTORY_HORIZON = ffi.C.CFG_HISTORY_LEN - 1
    local HISTORY_LEN = ffi.C.CFG_HISTORY_LEN
    local MAX_PLAYERS = ffi.C.CFG_MAX_PLAYERS

    local header_size = ffi.offsetof("LockstepPacket", "commands")
    local global_out_pkt = ffi.new("LockstepPacket")

    return {
        build_outbound = function(ctx, current_tick, conf_tick)
            ffi.fill(global_out_pkt, ffi.sizeof("LockstepPacket"), 0)
            local pkt = global_out_pkt

            pkt.session_token = ctx.session_token
            pkt.player_id = ctx.net_identity
            pkt.frame_tick = current_tick

            if ctx.rollback_arena.is_rollback_active == 0 then
                local conf_idx = bit.band(conf_tick, RING_MASK)
                pkt.state_checksum = ctx.rollback_arena.frames[conf_idx].state_checksum
                pkt.checksum_tick = conf_tick
            end

            local needed_base = math.max(0, current_tick - HISTORY_HORIZON)
            local history_count = math.min(HISTORY_LEN, current_tick - needed_base + 1)

            pkt.base_tick = needed_base
            pkt.history_count = history_count

            -- Populate Acks
            for p = 0, MAX_PLAYERS - 1 do
                if p ~= ctx.net_identity and ctx.peer_active[p] then
                    pkt.peer_acks[p] = ctx.peer_highest_tick[p]
                end
            end

            -- Direct 16-byte copy of history
            for i = 0, history_count - 1 do
                local h_idx = bit.band(needed_base + i, RING_MASK)
                local frame = ctx.rollback_arena.frames[h_idx]

                local src_ptr = ffi.cast("uint64_t*", frame.commands[ctx.net_identity])
                local dst_ptr = ffi.cast("uint64_t*", pkt.commands[i])
                dst_ptr[0] = src_ptr[0]
                dst_ptr[1] = src_ptr[1]
            end

            local payload_size = history_count * ffi.sizeof("PlayerCommand") * 2
            local final_size = header_size + payload_size

            return global_out_pkt, final_size
        end,

        get_header_size = function() return header_size end
    }
end

return Codec
