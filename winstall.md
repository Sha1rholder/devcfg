```ps1
irm https://get.activated.win | iex

winget source remove winget
winget source add winget https://mirrors.ustc.edu.cn/winget-source --trust-level trusted

winget pin add 2dust.v2rayN
winget pin add ZedIndustries.Zed
winget pin add Tencent.QQ.NT
winget pin add Tencent.WeChat.Universal
winget pin add kangfenmao.CherryStudio
winget pin add Tencent.QQMusic
winget pin add NetEase.CloudMusic
winget pin add Klocman.BulkCrapUninstaller
winget pin add Telegram.TelegramDesktop
winget pin add Valve.Steam
winget pin add EpicGames.EpicGamesLauncher
winget pin add 5E.5EClient
winget pin add PerfectWorld.PerfectWorldArena

Add-VpnConnection -Name "UoE" -ServerAddress "remote.net.ed.ac.uk" -TunnelType L2tp -L2tpPsk "Zt6337ZnVLhN" -Force # s2274292 Sdfsdf244244

winget install 2dust.v2rayN # https://api.tar-pits.com/5002af3a2490968494f5a746fe01603f/ngvqtnty9qb4qperoinbtqer
winget install Microsoft.PowerShell --source winget --installer-type wix

winget install Rime.Weasel
winget install GeekUninstaller.GeekUninstaller
winget install ZedIndustries.Zed

# winget install Mozilla.Firefox
winget install Tencent.QQ.NT

winget install jurplel.qView
winget install PeterPawlowski.foobar2000

winget install CharlesMilette.TranslucentTB
winget install SoftDeluxe.FreeDownloadManager
winget install 7zip.7zip

winget install kangfenmao.CherryStudio

winget install AlexanderKojevnikov.Spek
winget install Tencent.QQMusic
winget install NetEase.CloudMusic
winget install Telegram.TelegramDesktops

# Dev
winget install Gyan.FFmpeg
irm https://astral.sh/uv/install.ps1 | iex
uv python install
winget install CoreyButler.NVMforWindows
nvm install --lts
nvm use --lts
winget install mvdan.shfmt

winget install Git.Git
git config --global user.name "Sha1rholder"
git config --global user.email "sha1rholder@outlook.com"
winget install GitHub.cli
irm https://chatgpt.com/codex/install.ps1 | iex
# winget install RProject.R
# winget install RProject.Rtools
# winget install Posit.Ark

# Fun
winget install Valve.Steam
winget install EpicGames.EpicGamesLauncher
winget install 5E.5EClient
winget install PerfectWorld.PerfectWorldArena
```
