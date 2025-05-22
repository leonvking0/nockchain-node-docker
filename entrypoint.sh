#!/usr/bin/env bash
set -euo pipefail

BIN=nockchain
ROLE="${ROLE:-miner}"                  # miner | node
PUBKEY="${MINING_PUBKEY:-}"

case "$ROLE" in
  miner)
    : "${PUBKEY:?MINING_PUBKEY env var required for miner}"
    exec "$BIN" --mining-pubkey "$PUBKEY" --mine
    ;;
  node)
    exec "$BIN"
    ;;
  *)
    echo "❌ ROLE must be miner or node"; exit 1 ;;
esac
