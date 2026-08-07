#!/bin/bash
# sabotage.sh - Weaver Engine Chaos & Validation Tester

cd "$(dirname "$0")" || exit

echo "========================================================="
echo "  WEAVER ENGINE SABOTAGE PROTOCOL INITIATED"
echo "  Testing Lua Smart Floodgate Resilience..."
echo "========================================================="

# Helper function to execute and judge the engine's response
run_sabotage() {
    local test_name=$1
    local arg1=$2
    local arg2=$3
    local arg3=$4 # Optional, for testing the legacy 3-arg format

    echo -e "\n---> [TEST] $test_name"
    
    if [ -z "$arg3" ]; then
        echo "Executing: ./bin/boot.elf \"$arg1\" \"$arg2\""
        ./bin/boot.elf "$arg1" "$arg2"
    else
        echo "Executing: ./bin/boot.elf \"$arg1\" \"$arg2\" \"$arg3\""
        ./bin/boot.elf "$arg1" "$arg2" "$arg3"
    fi
    
    local exit_code=$?

    # Wir erwarten Exit Code 1 (Graceful FATAL im Lua-Skript)
    if [ $exit_code -eq 1 ]; then
        echo -e "\e[32m[PASS]\e[0m Engine rejected the garbage cleanly! (Exit Code: 1)"
    elif [ $exit_code -eq 0 ]; then
        echo -e "\e[31m[FAIL]\e[0m Engine accepted the garbage and kept running?! (Exit Code: 0)"
        # Kill it before it spawns a zombie thread
        pkill -9 -f "boot.elf"
    else
        echo -e "\e[33m[WARN]\e[0m Engine crashed hard! (Segfault/C-Panic? Exit Code: $exit_code)"
    fi
}

# ---------------------------------------------------------
# PHASE 1: MIXED VALIDITY (Ein Argument richtig, eins falsch)
# ---------------------------------------------------------

# Richtige Lobby ("host"), aber Size ist ein negativer Integer
run_sabotage "Valid Lobby / Negative Size" "host" "-4"

# Richtige Size (8), aber Lobby ist ein leerer String
run_sabotage "Empty Lobby / Valid Size" "" "8"

# Richtige Lobby ("E29B"), aber Size ist purer Text (Lua tonumber() wird scheitern)
run_sabotage "Valid Lobby / String Size" "E29B" "acht"

# Richtige Lobby, aber Size sprengt das C-Header Limit (CFG_MAX_PLAYERS)
run_sabotage "Valid Lobby / Exceeds Engine Limit" "host" "99"

# ---------------------------------------------------------
# PHASE 2: LEGACY FORMAT (Testet die 3-Argumente Auto-Detection)
# ---------------------------------------------------------

# Richtiges Legacy-Format, aber der Port ist Buchstaben-Müll
run_sabotage "Legacy Format: Garbage Port / Valid Lobby / Valid Size" "garbage_port" "host" "8"

# Port 0 (richtig), Valid Lobby, aber die Size fehlt (nur 2 args übergeben, obwohl es nach 3 aussieht)
run_sabotage "Legacy Format: Missing Size" "0" "E29B"

# ---------------------------------------------------------
# PHASE 3: ABSOLUTE ZERSTÖRUNG (Alles falsch)
# ---------------------------------------------------------

run_sabotage "Complete Garbage Injection" "DROP_TABLE" "-999" "xD"

run_sabotage "Too Few Arguments" "host"

echo -e "\n========================================================="
echo "  SABOTAGE PROTOCOL COMPLETE"
echo "========================================================="
