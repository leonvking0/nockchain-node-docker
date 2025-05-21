#!/usr/bin/env bash
set -euo pipefail

IMAGE_USER="${1:?<dockerhub-username>}"
TAG="${2:-$(date +%Y%m%d)}"
IMAGE="$IMAGE_USER/nockchain:$TAG"

docker build -t "$IMAGE" -t "$IMAGE_USER/nockchain:latest" .
docker push "$IMAGE"
docker push "$IMAGE_USER/nockchain:latest"

echo "✅ 已推送镜像: $IMAGE (latest 同步更新)"

