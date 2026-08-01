#!/usr/bin/env bash
set -Eeuo pipefail

# 声明路径
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
SCRIPT_PATH="${SCRIPT_DIR}/$(basename -- "${BASH_SOURCE[0]}")"
TEMP_DIR="${SCRIPT_DIR}/temp"

# 整个脚本统一使用root权限
if ((EUID != 0)); then
	exec sudo /usr/bin/env bash "$SCRIPT_PATH" "$@"
fi
cd -- "$SCRIPT_DIR"

# 确认允许非自由软件源
read -r -p 'Have you enabled non-free software sources? [Y/n] ' answer
case "$answer" in
'' | y | Y) ;;
*)
	printf 'Aborted.\n'
	exit 0
	;;
esac

LOG_FILE="/var/log/init0.log"
touch "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
printf '\n[%s] Start init0\n' "$(date '+%Y-%m-%d %H:%M:%S')"

TARGET_USER="sha1r"
OVERRIDE_FILE="/etc/dnf/repos.override.d/zz-cn-mirrors.repo"
mkdir -p -- "$TEMP_DIR"

die() {
	printf 'Error: %s\n' "$*" >&2
	exit 1
}

FEDORA_VERSION="$(rpm -E '%fedora')" # for x64 only

echo "Configure passwordless sudo for ${TARGET_USER}"

sudoers_tmp="$(mktemp "$TEMP_DIR/.${TARGET_USER}.XXXXXX")"

printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$TARGET_USER" >"$sudoers_tmp"

chmod 0440 "$sudoers_tmp"

visudo -cf "$sudoers_tmp" >/dev/null

mv -f -- "$sudoers_tmp" "/etc/sudoers.d/${TARGET_USER}"

if command -v restorecon >/dev/null 2>&1; then
	restorecon -F "/etc/sudoers.d/${TARGET_USER}" || true
fi

visudo -c >/dev/null

echo "Install RPM Fusion release packages"

dnf install -y "https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-${FEDORA_VERSION}.noarch.rpm" "https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_VERSION}.noarch.rpm"

echo "Write dnf mirror override configuration"

install -d -m 0755 /etc/dnf/repos.override.d

backup_file=""

if [[ -e "$OVERRIDE_FILE" ]]; then
	backup_file="${OVERRIDE_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
	cp -a -- "$OVERRIDE_FILE" "$backup_file"
fi

repo_tmp="$(
	mktemp "$TEMP_DIR/.zz-cn-mirrors.repo.XXXXXX"
)"

cat >"$repo_tmp" <<'REPO'
# Fedora official repo
# Covers only the download URL; GPG key, gpgcheck, enabled, and other settings inherit the system's original configuration.

[fedora]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/fedora/releases/$releasever/Everything/$basearch/os/

[updates]
metalink=
mirrorlist=
baseurl=https://mirrors.ustc.edu.cn/fedora/updates/$releasever/Everything/$basearch/

# RPM Fusion
# The corresponding repository is created by the `rpmfusion-*-release` packages.

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

echo "Clean the cache"
dnf clean all

echo "Verify modified repositories"

if ! dnf --refresh \
	--repo=fedora \
	--repo=updates \
	--repo=rpmfusion-free \
	--repo=rpmfusion-free-updates \
	--repo=rpmfusion-nonfree \
	--repo=rpmfusion-nonfree-updates \
	makecache; then
	echo "Mirror verification failed; restoring the original configuration." >&2

	if [[ -n "$backup_file" ]]; then
		cp -a -- "$backup_file" "$OVERRIDE_FILE"
	else
		rm -f -- "$OVERRIDE_FILE"
	fi

	dnf clean all || true
	exit 1
fi

dnf upgrade -y --refresh --allow-downgrade --allowerasing
systemctl reboot
