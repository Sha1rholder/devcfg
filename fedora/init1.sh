#!/usr/bin/env bash
set -Eeuo pipefail

# 保留安全启动能力并安装nvidia闭源驱动
sudo dnf install akmods kmodtool mokutil openssl
sudo test -f /etc/pki/akmods/certs/public_key.der || sudo kmodgenca -a
sudo ls -l /etc/pki/akmods/certs/public_key.der
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
printf '%s\n' \
	'重启' \
	'在蓝色 MOK 界面登记密钥' \
	'重启时应出现蓝色 MOK Manager：' \
	'选择 Enroll MOK' \
	'选择 Continue' \
	'选择 Yes' \
	'输入刚才设置的密码' \
	'选择 Reboot'
