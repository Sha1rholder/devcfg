# 新装Fedora KDE Plasma Desktop 44流程

```bash
# 免密码sudo
echo 'sha1r ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/sha1r >/dev/null && sudo chmod 440 /etc/sudoers.d/sha1r && sudo visudo -c
```

```bash
sudo dnf upgrade --refresh -y
sudo reboot
```

接受非自由软件源

配置nvidia显卡驱动

```bash
# 安装Microsoft Edge
flatpak install flathub com.microsoft.Edge
flatpak update
```

安装v2rayN并配置代理via：
<https://jp.tar-pits.com/f88e21891d4588f9p/v2rayN-linux-rhel-64.rpm>
<https://api.tar-pits.com/f88e21891d4588f9/48ff09d0881795ba>

```bash
# 添加nushell官方源
echo "[gemfury-nushell]
name=Gemfury Nushell Repo
baseurl=https://yum.fury.io/nushell/
enabled=1
gpgcheck=0
gpgkey=https://yum.fury.io/nushell/gpg.key" | sudo tee /etc/yum.repos.d/fury-nushell.repo
```

```bash
# 安装软件
sudo dnf install -y helix nushell ripgrep git gh uv rustup ffmpeg

curl -fSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
curl -fSL https://zed.dev/install.sh | bash
curl -fSL https://chatgpt.com/codex/install.sh | bash
```

```bash
# 同步 .config/
mkdir -p "$HOME/.config"
cp -a fedora/.config/. "$HOME/.config/"
```

```bash
# 初始化
git config --global user.name "Sha1rholder"
git config --global user.email "sha1rholder@outlook.com"
git config --global http.proxy socks5h://127.0.0.1:22727
git config --global https.proxy socks5h://127.0.0.1:22727
gh auth login
uv python install
rustup-init
nvm install --lts
corepack enable pnpm
rm -rf ~/.config/zed
gh repo clone Sha1rholder/zed-config ~/.config/zed -- --depth=1
pnpm add -g pake-cli
```

把nushell设为konsole默认shell

配置输入法
