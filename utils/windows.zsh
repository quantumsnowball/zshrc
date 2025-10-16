[[ -n "$WSL_DISTRO_NAME" ]] || return

# Windows path appending slows down shell installed() check significantly
#
# 1. disable append path to wsl by:
#   sudo nvim /etc/wsl.conf
#     [interop]
#     appendWindowsPath = false
# 2. then set alias to call useful windows app here below:
#

# explorer
alias explorer='/mnt/c/Windows/explorer.exe'
alias ex=explorer

# vscode
alias code="/mnt/c/Users/$(windows.whoami)/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"

# windows terminal
alias windows.terminal.config='nvim /mnt/c/Users/$(windows.whoami)/AppData/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json'
