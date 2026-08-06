#!/bin/bash
HOST_PORT=50000

# ==========================================
# SWARM CONFIGURATION
# ==========================================
HOST_TYPE="graphical"   # Options: "graphical" or "bot"
GRAPHICAL_CLIENTS=0     # Number of additional visual clients
BOT_CLIENTS=7           # Number of headless chaos bots

TOTAL_PLAYERS=$((1 + GRAPHICAL_CLIENTS + BOT_CLIENTS))

if [ "$TOTAL_PLAYERS" -gt 8 ]; then
    echo "[SWARM] FATAL: Total players ($TOTAL_PLAYERS) exceeds CFG_MAX_PLAYERS (8)."
    exit 1
fi
# ==========================================

echo "[SWARM] Orchestrating $TOTAL_PLAYERS-Node Match..."

# 1. Determine Host Binary
if [ "$HOST_TYPE" == "graphical" ]; then
# Here i am also missing the switch to toggle for linux ... and the sad part is that i cant use these scripts without msys2 and i cannot package accordingly i need a orchestrator .bat script that sits in the root directory that supports basic commandline functions ... we need basically 4-5 .bat scripts ... or really only half of that because on linux i can launch everything but the issue on linux is that i dont yet support dynamic launch capabilities like lets launch 4 bots only to this lobby that alone would solve a lot if i could launch two graphical clients manually and then attach 6 bots to that lobby
    HOST_BIN="./bin/boot.exe"
    echo "[SWARM] Booting Graphical Host Node on port $HOST_PORT..."
else
    HOST_BIN="./bin/boot_headless.exe"
    echo "[SWARM] Booting Headless Bot Host Node on port $HOST_PORT..."
fi

# 2. Inject Host
NODE_ROLE=host $HOST_BIN $HOST_PORT > host.log 2>&1 &
HOST_PID=$!
SWARM_PIDS=($HOST_PID)

echo "[SWARM] Waiting for Python Matchmaker to yield Lobby ID..."
while ! grep -q "LOBBY_ID:" host.log; do
    sleep 0.1
done

LOBBY_ID=$(grep "LOBBY_ID:" host.log | awk '{print $NF}')
echo "[SWARM] Established Network Lobby: $LOBBY_ID"
echo "[SWARM] Injecting $GRAPHICAL_CLIENTS Graphical Clients and $BOT_CLIENTS Bots..."

CLIENT_IDX=1

# 3. Inject Graphical Clients
for ((i=1; i<=GRAPHICAL_CLIENTS; i++)); do
    CLIENT_PORT=$((HOST_PORT + CLIENT_IDX))
    NODE_ROLE=client_$CLIENT_IDX ./bin/boot.exe $CLIENT_PORT $LOBBY_ID > client_${CLIENT_PORT}.log 2>&1 &
    SWARM_PIDS+=($!)
    echo " |- Spun up Graphical Client $CLIENT_IDX (Port: $CLIENT_PORT)"
    ((CLIENT_IDX++))
done

# 4. Inject Headless Bots
for ((i=1; i<=BOT_CLIENTS; i++)); do
    CLIENT_PORT=$((HOST_PORT + CLIENT_IDX))
    NODE_ROLE=bot_$CLIENT_IDX ./bin/boot_headless.exe $CLIENT_PORT $LOBBY_ID > client_${CLIENT_PORT}.log 2>&1 &
    SWARM_PIDS+=($!)
    echo " |- Spun up Chaos Bot $CLIENT_IDX (Port: $CLIENT_PORT)"
    ((CLIENT_IDX++))
done

echo "[SWARM] Synchronization active. Tailing host heartbeat..."
echo "[SWARM] (Client logs are muted. Check client_*.log when needed)"

# Tail ONLY the host to keep your terminal clean
tail -f host.log &
TAIL_PID=$!

echo "[SWARM] Waiting for manual node shutdown. You can close them in any order..."

# Wait specifically for the game PIDs to gracefully exit
for pid in "${SWARM_PIDS[@]}"; do
    wait $pid
done

echo "[SWARM] All squad nodes have shut down gracefully!"
echo "[SWARM] Wiping the background tail task..."
kill $TAIL_PID
