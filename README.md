
### 安装Docker (如果安装过，跳过这步)
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 克隆本项目
```
git clone https://github.com/leonvking0/nockchain-node-docker.git
cd nockchain-node-docker
```

### 给脚本可执行权限
```
chmod +x build_push.sh entrypoint.sh run_node.sh
```

### 自己build Docker镜像并上传到dockerhub, 需登录dockerhub账户(如果是x86架构用我的镜像就可以跳过这步)
```
./build_push.sh yourdockerhubname latest
```
### 钱包生成
```
docker run --rm \
  --entrypoint nockchain-wallet \
  h35xu/nockchain:latest \
  keygen | tr -d '\0' > wallet.txt
```
### 提取公钥并启动 leader 示例：
```
PUB=$(grep 'public key:' wallet.txt | sed -E 's/.*base58 "([^"]+)".*/\1/')
export MINING_PUBKEY="$PUB"
./run_node.sh leader                # 启动 leader
#./run_node.sh follower              # 若需 follower
```
### 查看日志
```
docker logs -f nck-leader
```
