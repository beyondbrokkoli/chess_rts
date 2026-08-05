-- lua/structs.lua
local ffi = require("ffi")

local M = {}

local function load_brutalist_structs()
    local file = assert(io.open("network/shared_structs.h", "r"), "[FATAL] Missing c/shared_structs.h")
    local c_code = file:read("*a")
    file:close()

    -- Scrub preprocessor macros so LuaJIT doesn't choke
    c_code = c_code:gsub("#[^\n]*\n", "\n")
    -- Scrub C11 Static asserts
    c_code = c_code:gsub("_Static_assert%([^;]-%);", "")

    -- Parse the raw, clean C structures
    ffi.cdef(c_code)
end

-- Run immediately
load_brutalist_structs()

-- Tenet II: The Sterile Tick (Weaponized)
function M.zero_memory(ffi_struct_ptr, struct_name)
    local size = ffi.sizeof(struct_name)
    ffi.fill(ffi_struct_ptr, size, 0)
end

return M
