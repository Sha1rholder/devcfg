## 手动

Add-VpnConnection -Name "UoE" -ServerAddress "remote.net.ed.ac.uk" -TunnelType L2tp -L2tpPsk "..." -Force

装v2rayN <https://api.tar-pits.com/5002af3a2490968494f5a746fe01603f/ngvqtnty9qb4qperoinbtqer>

装qq linux

```sh
#!/usr/bin/env bash

set -Eeuo pipefail

echo 'sha1r ALL=(ALL) NOPASSWD: ALL' | tee /etc/sudoers.d/sha1r
chmod 440 /etc/sudoers.d/sha1r

dnf config-manager addrepo --from-repofile=https://packages.microsoft.com/yumrepos/edge/config.repo
dnf upgrade --refresh -y
dnf install -y helix ibus-rime zsh ripgrep git gh powershell ffmpeg microsoft-edge-stable

USER_NAME="sha1r"
USER_HOME="/home/${USER_NAME}"
ZSHRC="${USER_HOME}/.zshrc"

chsh -s "$(command -v zsh)" "${USER_NAME}"

if ! grep -q 'fedora-kde-init proxy helpers' "${ZSHRC}" 2>/dev/null; then
	cat >>"${ZSHRC}" <<'EOF'

# fedora-kde-init proxy helpers
v2() {
	local proxy="socks5h://127.0.0.1:22727"
	export HTTP_PROXY="${proxy}"
	export HTTPS_PROXY="${proxy}"
	export ALL_PROXY="${proxy}"
	export http_proxy="${proxy}"
	export https_proxy="${proxy}"
	export all_proxy="${proxy}"
	export NO_PROXY="localhost,127.0.0.1,::1"
	export no_proxy="${NO_PROXY}"
	print -P "%F{green}Proxy Enabled -> ${proxy}%f"
}

v2h() {
	local proxy="http://127.0.0.1:22727"
	export HTTP_PROXY="${proxy}"
	export HTTPS_PROXY="${proxy}"
	export ALL_PROXY="${proxy}"
	export http_proxy="${proxy}"
	export https_proxy="${proxy}"
	export all_proxy="${proxy}"
	export NO_PROXY="localhost,127.0.0.1,::1"
	export no_proxy="${NO_PROXY}"
	print -P "%F{green}Proxy Enabled -> ${proxy}%f"
}

v2off() {
	unset HTTP_PROXY HTTPS_PROXY ALL_PROXY
	unset http_proxy https_proxy all_proxy
	unset NO_PROXY no_proxy
	print -P "%F{yellow}Proxy Disabled%f"
}
EOF
	chown "${USER_NAME}:${USER_NAME}" "${ZSHRC}"
fi

git config --global user.name "Sha1rholder"
git config --global user.email "sha1rholder@outlook.com"
git config --global http.proxy "socks5h://127.0.0.1:22727"
git config --global https.proxy "socks5h://127.0.0.1:22727"

curl -SL https://zed.dev/install.sh | bash

curl -SL https://astral.sh/uv/install.sh | bash
uv python install

gh auth login

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
nvm install --lts

curl -SL https://get.pnpm.io/install.sh | bash
curl --proto '=https' --tlsv1.2 -SL https://sh.rustup.rs | bash
curl -SL https://tombi-toml.github.io/tombi/install.sh | bash
curl -SL https://chatgpt.com/codex/install.sh | bash
```

装RTX5090驱动

```sh
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf install akmods kernel-devel kernel-headers gcc make
dnf install akmod-nvidia-open xorg-x11-drv-nvidia-cuda
akmods --force
modinfo -F version nvidia
dracut --force
# reboot
```
