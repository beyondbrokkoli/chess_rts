#!/bin/bash

# Force execution context to root
cd "$(dirname "$0")" || exit

BIN_EXT=".elf"
HOST_PORT=50000

usage() {
    echo "======================================================="
    echo "Weaver Engine Orchestrator (Linux)"
    echo "======================================================="
    echo "Usage:"
    echo "  ./launch.sh swarm [graphical_count] [bot_count]  - Spins up a local swarm cluster"
    echo "  ./launch.sh lab                                  - Spins up 4/4 split (4 graphical, 4 bots)"
    echo "  ./launch.sh host                                 - Boots a single graphical host node"
    echo "  ./launch.sh client [port] [lobby_id]             - Boots a graphical client to join a lobby"
    echo "  ./launch.sh attach [bot_count] [lobby_id]        - Injects headless bots to an existing lobby"
    echo "======================================================="
    exit 1
}

if [ "$#" -eq 0 ]; then usage; fi

COMMAND=$1

case $COMMAND in
    host)
        echo "[SWARM] Booting Graphical Host Node on port $HOST_PORT..."
        NODE_ROLE=host ./bin/boot$BIN_EXT $HOST_PORT > host.log 2>&1 &
        tail -f host.log
        ;;
        
    client)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "[ERROR] Usage: client [port] [lobby_id]"; exit 1; fi
        echo "[SWARM] Booting Graphical Client Node on port $2 joining Lobby $3..."
        NODE_ROLE=client_manual ./bin/boot$BIN_EXT "$2" "$3" > "client_$2.log" 2>&1 &
        ;;
        
    attach)
        if [ -z "$2" ] || [ -z "$3" ]; then echo "[ERROR] Usage: attach [bot_count] [lobby_id]"; exit 1; fi
        BOT_COUNT=$2
        LOBBY_ID=$3
        START_PORT=50050
        echo "[SWARM] Injecting $BOT_COUNT Headless Bots to Lobby $LOBBY_ID..."
        for ((i=1; i<=BOT_COUNT; i++)); do
            CLIENT_PORT=$((START_PORT + i))
            NODE_ROLE=bot_$i ./bin/boot_headless$BIN_EXT $CLIENT_PORT $LOBBY_ID > "client_${CLIENT_PORT}.log" 2>&1 &
            echo " |- Spun up Chaos Bot $i (Port: $CLIENT_PORT)"
        done
        ;;
        
    lab)
        $0 swarm 3 4
        ;;
        
    swarm)
        GRAPHICAL_CLIENTS=${2:-0}
        BOT_CLIENTS=${3:-7}
        TOTAL_PLAYERS=$((1 + GRAPHICAL_CLIENTS + BOT_CLIENTS))

        if [ "$TOTAL_PLAYERS" -gt 8 ]; then
            echo "[SWARM] FATAL: Total players ($TOTAL_PLAYERS) exceeds CFG_MAX_PLAYERS (8)."
            exit 1
        fi

        echo "[SWARM] Orchestrating $TOTAL_PLAYERS-Node Match..."
        
        NODE_ROLE=host ./bin/boot$BIN_EXT $HOST_PORT > host.log 2>&1 &
        HOST_PID=$!
        SWARM_PIDS=($HOST_PID)

        echo "[SWARM] Waiting for Python Matchmaker to yield Lobby ID..."
        while ! grep -q "LOBBY_ID:" host.log; do
            sleep 0.1
        done

        LOBBY_ID=$(grep "LOBBY_ID:" host.log | awk '{print $NF}')
        echo "[SWARM] Established Network Lobby: $LOBBY_ID"

        CLIENT_IDX=1

        # Graphical Clients
        for ((i=1; i<=GRAPHICAL_CLIENTS; i++)); do
            CLIENT_PORT=$((HOST_PORT + CLIENT_IDX))
            NODE_ROLE=client_$CLIENT_IDX ./bin/boot$BIN_EXT $CLIENT_PORT $LOBBY_ID > "client_${CLIENT_PORT}.log" 2>&1 &
            SWARM_PIDS+=($!)
            echo " |- Spun up Graphical Client $CLIENT_IDX (Port: $CLIENT_PORT)"
            ((CLIENT_IDX++))
        done

        # Headless Bots
        for ((i=1; i<=BOT_CLIENTS; i++)); do
            CLIENT_PORT=$((HOST_PORT + CLIENT_IDX))
            NODE_ROLE=bot_$CLIENT_IDX ./bin/boot_headless$BIN_EXT $CLIENT_PORT $LOBBY_ID > "client_${CLIENT_PORT}.log" 2>&1 &
            SWARM_PIDS+=($!)
            echo " |- Spun up Chaos Bot $CLIENT_IDX (Port: $CLIENT_PORT)"
            ((CLIENT_IDX++))
        done

        echo "[SWARM] Synchronization active. Tailing host heartbeat..."
        tail -f host.log &
        TAIL_PID=$!

        echo "[SWARM] Waiting for manual node shutdown..."
        for pid in "${SWARM_PIDS[@]}"; do
            wait $pid
        done

        echo "[SWARM] All squad nodes have shut down gracefully!"
        kill $TAIL_PID 2>/dev/null
        ;;
        
    *)
        usage
        ;;
esac
