#!/bin/bash
HOST_PORT=50000

echo "[SWARM] Booting 4/4 Split Lab (4 Graphical, 4 Bots)..."

# 1. Host (Graphical)
NODE_ROLE=host ./bin/boot.exe $HOST_PORT > host.log 2>&1 &
HOST_PID=$!
SWARM_PIDS=($HOST_PID)

echo "[SWARM] Waiting for Python Matchmaker to yield Lobby ID..."
while ! grep -q "LOBBY_ID:" host.log; do
    sleep 0.1
done

LOBBY_ID=$(grep "LOBBY_ID:" host.log | awk '{print $NF}')
echo "[SWARM] Established Network Lobby: $LOBBY_ID"

CLIENT_IDX=1

# 2. Inject 3 Graphical Clients (Total 4 visual nodes including host)
for i in {1..3}; do
    CLIENT_PORT=$((HOST_PORT + CLIENT_IDX))
    NODE_ROLE=client_$CLIENT_IDX ./bin/boot.exe $CLIENT_PORT $LOBBY_ID > client_${CLIENT_PORT}.log 2>&1 &
    SWARM_PIDS+=($!)
    echo " |- Spun up Graphical Client $CLIENT_IDX (Port: $CLIENT_PORT)"
    ((CLIENT_IDX++))
done

# 3. Inject 4 Headless Bots (Total 8 nodes)
for i in {1..4}; do
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
