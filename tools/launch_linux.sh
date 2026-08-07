#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <port> [lobby_id]"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[LINUX] Booting Graphical Host Node on port $1..."
    NODE_ROLE="host" ./bin/boot.elf "$@"
else
    echo "[LINUX] Booting Graphical Client Node on port $1 joining Lobby $2..."
    NODE_ROLE="client_1" ./bin/boot.elf "$@"
fi
