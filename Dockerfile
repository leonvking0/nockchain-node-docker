############################################################
# 1️⃣  Build stage – 编译所有二进制
############################################################
FROM rust:1.77-bookworm AS builder

# 安装构建依赖（保持最小）
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        git make clang pkg-config libssl-dev libleveldb-dev && \
    rm -rf /var/lib/apt/lists/*

# 拉取源码（如要锁版本，把 main 换成 tag/commit）
ARG NCK_COMMIT=master
RUN git clone --depth 1 --branch ${NCK_COMMIT} https://github.com/zorp-corp/nockchain /src
WORKDIR /src

# 编译：生成 nockchain + nockchain-wallet
RUN make build                 && \
    make install-nockchain     && \
    make install-nockchain-wallet

# ---------- Runtime stage ----------
FROM debian:bookworm-slim AS runtime

# 复制二进制
COPY --from=builder /src/target/release/nockchain        /usr/local/bin/
COPY --from=builder /src/target/release/nockchain-wallet /usr/local/bin/

# 复制入口脚本并直接赋可执行权限（BuildKit 语法）
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# 依赖的动态库
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        libssl3 libleveldb1d ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 非 root 运行
RUN useradd -m -u 1000 nck
USER nck
WORKDIR /home/nck

# UDP 端口
EXPOSE 3005/udp 3006/udp
ENTRYPOINT ["/entrypoint.sh"]

