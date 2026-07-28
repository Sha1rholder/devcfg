# 新装Ubuntu 26.04 LTS流程

```bash
# 免密码sudo
echo 'sha1r ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/sha1r >/dev/null && sudo chmod 440 /etc/sudoers.d/sha1r && sudo visudo -c
```

```bash
# 更新系统
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

配置nvidia显卡驱动

安装Microsoft Edge via <https://explore.microsoft.com/en-us/edge/download>

安装v2rayN并配置代理via <https://jp.tar-pits.com/f88e21891d4588f9p/v2rayN-linux-rhel-64.rpm> and <https://api.tar-pits.com/f88e21891d4588f9/48ff09d0881795ba>

```bash
# 添加Nushell官方源
wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg
echo "deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /" | sudo tee /etc/apt/sources.list.d/fury-nushell.list
sudo apt update
sudo apt install -y nushell
```

```bash
# 安装软件
sudo apt install -y curl helix ripgrep git gh uv rustup ffmpeg

curl -fSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
curl -fSL https://zed.dev/install.sh | bash
curl -fSL https://chatgpt.com/codex/install.sh | bash
```

```bash
# 同步 .config/
mkdir -p "$HOME/.config"
cp -a ubuntu/.config/. "$HOME/.config/"
```

```bash
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
```

把nushell设为默认shell

配置输入法
