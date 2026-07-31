#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

# 整个脚本统一使用 root 权限
if ((EUID != 0)); then
	exec sudo /usr/bin/env bash "$0" "$@"
fi

TARGET_USER="sha1r"
OVERRIDE_FILE="/etc/dnf/repos.override.d/zz-cn-mirrors.repo"

die() {
	printf '错误：%s\n' "$*" >&2
	exit 1
}

command -v dnf5 >/dev/null 2>&1 ||
	die "没有找到 dnf5"

command -v visudo >/dev/null 2>&1 ||
	die "没有找到 visudo"

FEDORA_VERSION="$(rpm -E '%fedora')"
BASE_ARCH="$(rpm -E '%_arch')"

[[ "$FEDORA_VERSION" == "44" ]] ||
	die "此脚本仅适用于 Fedora 44，当前为 Fedora ${FEDORA_VERSION}"

[[ "$BASE_ARCH" == "x86_64" ]] ||
	die "USTC Fedora 镜像当前仅标注支持 x86_64，当前架构为 ${BASE_ARCH}"

id "$TARGET_USER" >/dev/null 2>&1 ||
	die "用户 ${TARGET_USER} 不存在"

sudoers_tmp=""
repo_tmp=""

cleanup() {
	if [[ -n "$sudoers_tmp" ]]; then
		rm -f -- "$sudoers_tmp"
	fi

	if [[ -n "$repo_tmp" ]]; then
		rm -f -- "$repo_tmp"
	fi
}

trap cleanup EXIT

echo "==> 配置 ${TARGET_USER} 免密码 sudo"

sudoers_tmp="$(mktemp "/etc/sudoers.d/.${TARGET_USER}.XXXXXX")"

printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$TARGET_USER" \
	>"$sudoers_tmp"

chmod 0440 "$sudoers_tmp"

visudo -cf "$sudoers_tmp" >/dev/null

mv -f -- "$sudoers_tmp" "/etc/sudoers.d/${TARGET_USER}"
sudoers_tmp=""

if command -v restorecon >/dev/null 2>&1; then
	restorecon -F "/etc/sudoers.d/${TARGET_USER}" || true
fi

visudo -c >/dev/null

echo "==> 安装 RPM Fusion release 包"

dnf5 install -y \
	"https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" \
	"https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

echo "==> 写入 DNF5 国内镜像覆盖配置"

install -d -m 0755 /etc/dnf/repos.override.d

backup_file=""

if [[ -e "$OVERRIDE_FILE" ]]; then
	backup_file="${OVERRIDE_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
	cp -a -- "$OVERRIDE_FILE" "$backup_file"
fi

repo_tmp="$(
	mktemp /etc/dnf/repos.override.d/.zz-cn-mirrors.repo.XXXXXX
)"

cat >"$repo_tmp" <<'REPO'
# Fedora 官方仓库
# 仅覆盖下载地址；GPG key、gpgcheck、enabled 等继承系统原配置。

[fedora]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/fedora/releases/$releasever/Everything/$basearch/os/

[updates]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/fedora/updates/$releasever/Everything/$basearch/

# RPM Fusion
# 对应仓库由 rpmfusion-*-release 软件包创建。

[rpmfusion-free]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/releases/$releasever/Everything/$basearch/os/

[rpmfusion-free-updates]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/updates/$releasever/$basearch/

[rpmfusion-nonfree]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/releases/$releasever/Everything/$basearch/os/

[rpmfusion-nonfree-updates]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/updates/$releasever/$basearch/
REPO

chmod 0644 "$repo_tmp"
mv -f -- "$repo_tmp" "$OVERRIDE_FILE"
repo_tmp=""

echo "==> 清理缓存"
dnf5 clean all

echo "==> 验证已修改的仓库"

if ! dnf5 --refresh \
	--repo=fedora \
	--repo=updates \
	--repo=rpmfusion-free \
	--repo=rpmfusion-free-updates \
	--repo=rpmfusion-nonfree \
	--repo=rpmfusion-nonfree-updates \
	makecache; then
	echo "镜像验证失败，正在恢复原配置。" >&2

	if [[ -n "$backup_file" ]]; then
		cp -a -- "$backup_file" "$OVERRIDE_FILE"
	else
		rm -f -- "$OVERRIDE_FILE"
	fi

	dnf5 clean all || true
	exit 1
fi

echo "==> 更新系统"
dnf5 upgrade -y
systemctl reboot
