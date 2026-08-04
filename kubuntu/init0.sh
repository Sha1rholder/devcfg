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

LOG_FILE="/var/log/init0.log"
TARGET_USER="sha1r"
SOURCE_FILE="/etc/apt/sources.list.d/ubuntu.sources"
backup_file=""
sudoers_tmp=""
source_tmp=""

mkdir -p -- "$TEMP_DIR"
touch "$LOG_FILE"
exec > >(tee -a "$LOG_FILE") 2>&1
printf '\n[%s] Start init0\n' "$(date '+%Y-%m-%d %H:%M:%S')"

# 输出错误并退出
die() {
	printf 'Error: %s\n' "$*" >&2
	exit 1
}

# 删除临时文件
cleanup() {
	if [[ -n "$sudoers_tmp" ]]; then
		rm -f -- "$sudoers_tmp"
	fi

	if [[ -n "$source_tmp" ]]; then
		rm -f -- "$source_tmp"
	fi
}

# 恢复原软件源
restore_sources() {
	if [[ -n "$backup_file" ]]; then
		cp -a -- "$backup_file" "$SOURCE_FILE"
	else
		rm -f -- "$SOURCE_FILE"
	fi
}

trap cleanup EXIT

[[ -r /etc/os-release ]] || die 'Cannot read /etc/os-release'
source /etc/os-release

[[ "${ID:-}" == "ubuntu" ]] || die 'This script only supports Ubuntu'
[[ "${VERSION_ID:-}" == "26.04" ]] || die 'This script only supports Ubuntu 26.04'
[[ "${VERSION_CODENAME:-}" == "resolute" ]] || die 'Expected Ubuntu codename resolute'
[[ "$(dpkg --print-architecture)" == "amd64" ]] || die 'This script only supports amd64'
id "$TARGET_USER" >/dev/null 2>&1 || die "User ${TARGET_USER} does not exist"

printf 'Configure passwordless sudo for %s\n' "$TARGET_USER"

sudoers_tmp="$(mktemp "${TEMP_DIR}/.${TARGET_USER}.XXXXXX")"
printf '%s ALL=(ALL:ALL) NOPASSWD: ALL\n' "$TARGET_USER" >"$sudoers_tmp"
chmod 0440 "$sudoers_tmp"
visudo -cf "$sudoers_tmp" >/dev/null
mv -f -- "$sudoers_tmp" "/etc/sudoers.d/${TARGET_USER}"
sudoers_tmp=""
visudo -c >/dev/null

printf 'Write APT mirror configuration\n'

install -d -m 0755 /etc/apt/sources.list.d

if [[ -e "$SOURCE_FILE" ]]; then
	backup_file="${SOURCE_FILE}.bak.$(date +%Y%m%d-%H%M%S)"
	cp -a -- "$SOURCE_FILE" "$backup_file"
fi

source_tmp="$(mktemp "${TEMP_DIR}/.ubuntu.sources.XXXXXX")"

cat >"$source_tmp" <<'SOURCES'
# Ubuntu基础、更新和回移植仓库
Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: resolute resolute-updates resolute-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Ubuntu安全更新仓库
Types: deb
URIs: https://mirrors.ustc.edu.cn/ubuntu
Suites: resolute-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
SOURCES

chmod 0644 "$source_tmp"
mv -f -- "$source_tmp" "$SOURCE_FILE"
source_tmp=""

printf 'Verify modified repositories\n'

if ! apt-get update; then
	printf 'Mirror verification failed; restoring the original configuration\n' >&2
	restore_sources
	apt-get update || true
	exit 1
fi

DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y
systemctl reboot
