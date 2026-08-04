# 新装Kubuntu 26.04 LTS流程

本方案仅支持amd64，依次执行两个阶段

## 第一阶段

运行系统初始化脚本，脚本将配置免密码sudo、切换USTC软件源、更新系统并自动重启

```bash
bash kubuntu/init0.sh
```

## 安装桌面软件

通过<https://explore.microsoft.com/en-us/edge/download>安装Microsoft Edge

通过<https://jp.tar-pits.com/f88e21891d4588f9p/v2rayN-linux-64.deb>安装v2rayN，并使用<https://api.tar-pits.com/f88e21891d4588f9/48ff09d0881795ba>配置订阅

## 第二阶段

重启后运行用户环境初始化脚本，按提示完成GitHub和Rustup交互

```bash
bash kubuntu/init1.sh
```

把Nushell设为默认shell

配置输入法
