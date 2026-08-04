#!/usr/bin/env bash
set -Eeuo pipefail

# 声明路径
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd -- "$SCRIPT_DIR"

KEYRING_FILE="/etc/apt/keyrings/fury-nushell.gpg"
SOURCE_FILE="/etc/apt/sources.list.d/fury-nushell.list"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
export PATH="$HOME/.local/bin:$PATH"

# 安装软件源依赖
sudo apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gnupg

# 添加Nushell官方源
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor --yes --output "$KEYRING_FILE"
printf '%s\n' 'deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /' | sudo tee "$SOURCE_FILE" >/dev/null
sudo apt-get update

# 安装仓库软件
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y nushell hx ripgrep git gh rustup ffmpeg

# 安装用户级工具
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="$HOME/.local/bin" sh
curl -fSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash

if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
	printf 'Error: nvm.sh was not installed\n' >&2
	exit 1
fi

source "$NVM_DIR/nvm.sh"
nvm install --lts
corepack enable pnpm

curl -fSL https://zed.dev/install.sh | bash
curl -fSL https://chatgpt.com/codex/install.sh | bash

# 同步.config
mkdir -p -- "$HOME/.config"
cp -a -- .config/. "$HOME/.config/"

# 初始化开发环境
git config --global user.name "Sha1rholder"
git config --global user.email "sha1rholder@outlook.com"
git config --global http.proxy "socks5h://127.0.0.1:22727"
git config --global https.proxy "socks5h://127.0.0.1:22727"
gh auth login
uv python install
rustup-init
rm -rf -- "${HOME:?}/.config/zed"
gh repo clone Sha1rholder/zed-config "$HOME/.config/zed" -- --depth=1
pnpm add -g pake-cli
