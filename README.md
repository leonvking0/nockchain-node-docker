
# 自己build Docker镜像并上传到dockerhub, 需登录dockerhub账户(如果是x86架构用我的镜像就行)
./build_push.sh yourdockerhubname latest

# 钱包生成
mkdir -p ~/nck_wallet && cd ~/nck_wallet && umask 077

docker run --rm \
  --entrypoint nockchain-wallet \
  h35xu/nockchain:latest \
  keygen | tr -d '\0' > wallet.txt

# 提取公钥并启动 leader 示例：
PUB=$(grep 'public key:' wallet.txt | sed -E 's/.*base58 "([^"]+)".*/\1/')
export MINING_PUBKEY="$PUB"
./run_node.sh leader                # 启动 leader
./run_node.sh follower              # 若需 follower

# 查看日志
docker logs -f nck-leader
 
