# 添加Nushell官方源
wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg
echo "deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury-nushell.list
sudo apt update
sudo apt install -y nushell

# 安装软件
sudo apt install -y curl helix ripgrep git gh uv rustup ffmpeg

curl -fSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
curl -fSL https://zed.dev/install.sh | bash
curl -fSL https://chatgpt.com/codex/install.sh | bash

# 同步 .config/
mkdir -p "$HOME/.config"
cp -a ubuntu/.config/. "$HOME/.config/"

# 初始化
git config --global user.name "Sha1rholder"
git config --global user.email "sha1rholder@outlook.com"
git config --global http.proxy "socks5h://127.0.0.1:22727"
git config --global https.proxy "socks5h://127.0.0.1:22727"
gh auth login
uv python install
rustup-init
nvm install --lts
corepack enable pnpm
rm -rf ~/.config/zed
gh repo clone Sha1rholder/zed-config ~/.config/zed -- --depth=1
pnpm add -g pake-cli
