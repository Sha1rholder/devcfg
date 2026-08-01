#!/usr/bin/env bash
set -Eeuo pipefail

# 声明路径
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_PATH="${SCRIPT_DIR}/$(basename -- "${BASH_SOURCE[0]}")"
cd -- "$SCRIPT_DIR"

# 添加Nushell官方源
printf '%s\n' '[gemfury-nushell]' 'name=Gemfury Nushell Repo' 'baseurl=https://yum.fury.io/nushell/' 'enabled=1' 'gpgcheck=0' 'gpgkey=https://yum.fury.io/nushell/gpg.key' | sudo tee /etc/yum.repos.d/fury-nushell.repo >/dev/null
sudo dnf install -y nushell

# 安装软件
sudo dnf install -y helix ripgrep git gh uv rustup ffmpeg

curl -fSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
curl -fSL https://zed.dev/install.sh | bash
curl -fSL https://chatgpt.com/codex/install.sh | bash

# 同步 .config/
mkdir -p -- "$HOME/.config"
cp -a -- .config/. "$HOME/.config/"

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
rm -rf -- "$HOME/.config/zed"
gh repo clone Sha1rholder/zed-config "$HOME/.config/zed" -- --depth=1
pnpm add -g pake-cli
