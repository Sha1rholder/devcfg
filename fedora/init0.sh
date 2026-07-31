# 免密码sudo
echo 'sha1r ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/sha1r >/dev/null && sudo chmod 440 /etc/sudoers.d/sha1r && sudo visudo -c

# 更新系统
sudo dnf upgrade --refresh -y
sudo reboot
