-- seam_tracer.lua (v5 - Optimized & Swarm Safe)

local original_require = require

local role = os.getenv("NODE_ROLE") or (arg and arg[1]) or ("node_" .. math.random(1000))
local filename = string.format("seam_trace_%s.log", role)
local trace_file = io.open(filename, "w") or io.open("bin/" .. filename, "w")

local trace_dirs = { "staging", "ssot", "network", "engine", "build" }

local seen_seams = {}
local seam_counts = {}

local function should_trace_file(filepath)
    if not filepath then return false end
    for _, dir in ipairs(trace_dirs) do
        if filepath:find("/" .. dir .. "/", 1, true) or filepath:find("\\" .. dir .. "\\", 1, true) then
            return true
        end
    end
    return false
end

local function proxy_module(mod_name, mod, filepath)
    if type(mod) ~= "table" then return mod end

    -- THE FIX: Cache wrappers per function to prevent allocating a new closure on every __index hit
    local wrapper_cache = {}

    return setmetatable({}, {
        __index = function(t, k)
            local v = mod[k]
            if type(v) == "function" then
                if not wrapper_cache[k] then
                    wrapper_cache[k] = function(...)
                        -- OPTIMIZATION: debug.getinfo is slow.
                        -- If you don't strictly need the caller line, comment this out and
                        -- just use: local key = mod_name .. "." .. k
                        local info = debug.getinfo(2, "Sl")
                        local caller_src = info and info.short_src or "C"
                        local caller_line = info and info.currentline or 0

                        -- OPTIMIZATION: Concatenation is much faster than string.format
                        local key = caller_src .. ":" .. caller_line .. "->" .. mod_name .. "." .. k

                        seam_counts[key] = (seam_counts[key] or 0) + 1

                        if not seen_seams[key] then
                            seen_seams[key] = true
                            local log_line = "[SEAM] " .. key .. " (via " .. (filepath or "?") .. ")"
                            print(log_line)
                            if trace_file then
                                trace_file:write(log_line .. "\n")
                                trace_file:flush()
                            end
                        end

                        return v(...)
                    end
                end
                return wrapper_cache[k]
            end
            return v
        end,
        __newindex = function(t, k, v) mod[k] = v end,
        __metatable = "SeamTracerProxy"
    })
end

function require(modname)
    if package.loaded[modname] then return package.loaded[modname] end
    local filepath = package.searchpath(modname, package.path)
    local mod = original_require(modname)

    if should_trace_file(filepath) then
        local proxied = proxy_module(modname, mod, filepath)
        package.loaded[modname] = proxied
        return proxied
    end
    return mod
end

local function dump_summary()
    if not trace_file then return end

    trace_file:write("\n\n========================================\n")
    trace_file:write("       SEAM FREQUENCY SUMMARY (HOT PATHS)\n")
    trace_file:write("========================================\n")

    local sorted_seams = {}
    for key, count in pairs(seam_counts) do
        table.insert(sorted_seams, {key = key, count = count})
    end

    table.sort(sorted_seams, function(a, b) return a.count > b.count end)

    local limit = math.min(50, #sorted_seams)
    for i = 1, limit do
        local entry = sorted_seams[i]
        trace_file:write(string.format("[%06d calls] %s\n", entry.count, entry.key))
    end

    trace_file:write("========================================\n")
    print(string.format("[SEAM TRACER] Done. Top hot path had %d calls. Check %s.",
        sorted_seams[1] and sorted_seams[1].count or 0, filename))
end

if trace_file then
    local orig_exit = os.exit
    os.exit = function(...)
        dump_summary()
        trace_file:close()
        orig_exit(...)
    end
end
