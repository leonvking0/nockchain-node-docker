#!/usr/bin/env bash
set -euo pipefail

IMAGE="h35xu/nockchain:latest"   # 换成你的镜像
ROLE="${1:-leader}"              # leader | follower
PUBKEY="${MINING_PUBKEY:?need-it}"
NAME="nck-$ROLE"

docker pull "$IMAGE"

docker run -d --name "$NAME" \
  -e ROLE="$ROLE" \
  -e MINING_PUBKEY="$PUBKEY" \
  -p 3005:3005/udp \
  -p 3006:3006/udp \
  "$IMAGE"

echo "✅ $ROLE 节点已启动，查看日志：docker logs -f $NAME"

