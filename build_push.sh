#!/usr/bin/env bash
#!/usr/bin/env bash
set -euo pipefail
IMG_USER="${1:?dockerhub-username}"
TAG="${2:-$(date +%Y%m%d)}"
docker buildx build --platform linux/amd64,linux/arm64 \
  -t $IMG_USER/nockchain:$TAG \
  -t $IMG_USER/nockchain:latest \
  --push .

echo "✅ 已推送镜像: $IMAGE (latest 同步更新)"

