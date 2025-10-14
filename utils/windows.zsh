[[ -n "$WSL_DISTRO_NAME" ]] || return

# Windows path appending slows down shell installed() check significantly
#
# 1. disable append path to wsl by:
#   sudo nvim /etc/wsl.conf
#     [interop]
#     appendWindowsPath = false
# 2. then set alias to call useful windows app here below:
#

# whoami
windows.whoami() {
    /mnt/c/Windows/System32/whoami.exe | awk -F'\\' '{print $2}' | tr -d '\r'
}

# explorer
alias explorer='/mnt/c/Windows/explorer.exe'
alias ex=explorer

# vscode
alias code='/winhost/home/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code'

# windows terminal
alias windows.terminal.config='nvim ~/winhost/home/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json'
