-- network/fsm_pacing.lua
local Pacing = {}

function Pacing.calculate_horizons(ctx, FIXED_DT, MAX_PLAYERS, LOOKAHEAD_CAP)
    local true_consensus = 0xFFFFFFFF
    local min_ack_of_me = 0xFFFFFFFF

    -- 1. Gather network acks
    for p = 0, MAX_PLAYERS - 1 do
        if p ~= ctx.net_identity and ctx.peer_active[p] then
            if ctx.peer_highest_tick[p] < true_consensus then
                true_consensus = ctx.peer_highest_tick[p]
            end
            if ctx.peer_ack_of_me[p] < min_ack_of_me then
                min_ack_of_me = ctx.peer_ack_of_me[p]
            end
        end
    end

    -- 2. Clamp and update confirmed tick
    local local_max_valid_tick = math.max(0, ctx.sim_tick_count - 1)
    if true_consensus > local_max_valid_tick then
        true_consensus = local_max_valid_tick
    end
    if true_consensus ~= 0xFFFFFFFF and true_consensus > ctx.rollback_arena.confirmed_tick then
        ctx.rollback_arena.confirmed_tick = true_consensus
    end

    if min_ack_of_me == 0xFFFFFFFF then
        min_ack_of_me = ctx.rollback_arena.confirmed_tick
    end

    local remote_highest = ctx.rollback_arena.confirmed_tick
    local safe_horizon = math.min(remote_highest, min_ack_of_me)

    -- 3. Temporal pacing (Speed up or Pause based on network pressure)
    if remote_highest > ctx.sim_tick_count + 2 then
        ctx.accumulator = ctx.accumulator + ((remote_highest - ctx.sim_tick_count) * FIXED_DT)
    end

    if ctx.sim_tick_count > safe_horizon + LOOKAHEAD_CAP then
        ctx.accumulator = 0 -- Halt simulation until peers catch up
    end

    return remote_highest
end

return Pacing
