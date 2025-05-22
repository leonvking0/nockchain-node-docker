#!/usr/bin/env bash
set -euo pipefail

IMAGE="h35xu/nockchain:latest"   # 改成你的仓库
ROLE="${1:-miner}"               # miner | node
PUBKEY="${MINING_PUBKEY:-}"      # miner 需提供

docker pull "$IMAGE"

docker run -d --name "nck-$ROLE" \
  -e ROLE="$ROLE" \
  -e MINING_PUBKEY="$PUBKEY" \
  -p 3005:3005/udp \
  -p 3006:3006/udp \
  "$IMAGE"

echo "✔️  容器启动完成：docker logs -f nck-$ROLE"
