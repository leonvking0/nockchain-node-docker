############################################################
# 1️⃣  Build stage
############################################################
FROM rust:1.77-bookworm AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        clang llvm-dev libclang-dev libssl-dev libleveldb-dev pkg-config git make && \
    rm -rf /var/lib/apt/lists/*

ARG NCK_COMMIT=master
RUN git clone --depth 1 --branch ${NCK_COMMIT} https://github.com/zorp-corp/nockchain /src
WORKDIR /src

# 按 README 步骤
RUN make install-hoonc \
 && make build \
 && make install-nockchain-wallet \
 && make install-nockchain

############################################################
# 2️⃣  Runtime stage
############################################################
FROM debian:bookworm-slim AS runtime
LABEL maintainer="you@example.com"

# 二进制
COPY --from=builder /src/target/release/nockchain        /usr/local/bin/
COPY --from=builder /src/target/release/nockchain-wallet /usr/local/bin/

# 入口脚本
COPY --chmod=755 entrypoint.sh /entrypoint.sh

# 运行所需动态库
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        libssl3 libleveldb1d ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 nck
USER nck
WORKDIR /home/nck

# -- 显式声明 UDP 3005/3006 --
EXPOSE 3005/udp 3006/udp
ENTRYPOINT ["/entrypoint.sh"]
