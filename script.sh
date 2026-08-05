#!/bin/bash
set -e

echo "1. Flattening the strict folder requires inside the Chess World..."
# Converts require("display/board") -> require("board"), allowing the new path resolver to find it
find worlds/chess -name "*.lua" -type f -exec sed -i -E 's/require\("display\/(.*)"\)/require("\1")/g' {} +
find worlds/chess -name "*.lua" -type f -exec sed -i -E 's/require\("game\/(.*)"\)/require("\1")/g' {} +

echo "2. Fixing hardcoded engine require paths..."
# The engine had a few explicitly nested requires that we need to flatten
sed -i 's/require("engine\.teardown")/require("teardown")/g' runtime/boot/main.lua
sed -i 's/require("network\.history_buffer")/require("history_buffer")/g' network/transport/net_pump.lua
sed -i 's/require("network\.wire_codec")/require("wire_codec")/g' network/transport/net_pump.lua

echo "3. Removing legacy package.path hacks..."
# Strip any line setting package.path = ... out of the entry points
sed -i '/package\.path.*=/d' runtime/boot/main.lua
sed -i '/package\.path.*=/d' network/session/netcode.lua
sed -i '/package\.path.*=/d' tools/bot.lua

echo "4. Generating the Omnipath Weaver..."
# Creates a single boot-time script that exposes all our new namespaces
cat << 'EOF' > runtime/boot/path_weaver.lua
-- Maps the engine's architectural DAG into Lua's flat module resolver
local roots = {
    "ssot",
    "runtime/boot",
    "runtime/presentation/graphics",
    "runtime/presentation/translation",
    "runtime/services/gpu",
    "runtime/services/math",    -- Ensures fixed_math.lua resolves natively for deterministic state
    "runtime/services/memory",
    "runtime/services/tenants",
    "runtime/shutdown",
    "runtime/simulation",
    "network/lockstep",
    "network/protocol",
    "network/session",
    "network/transport",
    "worlds/chess",
    "worlds/chess/commands",
    "worlds/chess/frontend",
    "worlds/chess/rules",
    "worlds/chess/state",
    "tools"
}

-- Ensure root is checked first
package.path = "./?.lua;" .. package.path

-- Inject our new DAG into the search path
for i = #roots, 1, -1 do
    package.path = "./" .. roots[i] .. "/?.lua;" .. package.path
end
EOF

echo "5. Injecting the Weaver into entry points..."
# Injects the module at the very top (line 1) of our executables
sed -i '1i require("runtime.boot.path_weaver")' runtime/boot/main.lua
sed -i '1i require("runtime.boot.path_weaver")' network/session/netcode.lua
sed -i '1i require("runtime.boot.path_weaver")' tools/bot.lua

echo "Require resolution complete."
