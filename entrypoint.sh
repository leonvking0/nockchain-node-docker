#!/usr/bin/env bash
set -euo pipefail

BIN=nockchain                         # 二进制名字
ROLE="${ROLE:-leader}"               # leader | follower
PUBKEY="${MINING_PUBKEY:?need-it}"   # 必填，否则 exit
DATA_DIR="/home/nck/test-${ROLE}"    # 跟 Makefile 保持目录名
NPC_SOCK="nockchain.sock"

mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
rm -f "$NPC_SOCK"

common=(
  --fakenet
  --npc-socket "$NPC_SOCK"
  --mining-pubkey "$PUBKEY"
  --new-peer-id
  --no-default-peers
)

case "$ROLE" in
  leader)
    exec "$BIN" \
      "${common[@]}" \
      --genesis-leader \
      --bind /ip4/0.0.0.0/udp/3005/quic-v1 \
      --peer /ip4/127.0.0.1/udp/3006/quic-v1
    ;;
  follower)
    exec "$BIN" \
      "${common[@]}" \
      --genesis-watcher \
      --bind /ip4/0.0.0.0/udp/3006/quic-v1 \
      --peer /ip4/127.0.0.1/udp/3005/quic-v1
    ;;
  *)
    echo "❌ ROLE must be leader or follower"; exit 1 ;;
esac

