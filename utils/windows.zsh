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
alias explorer="$WINDOWS_WINDOWS/explorer.exe"
alias ex=explorer

# vscode
alias code="$WINDOWS_APPDATA/Local/Programs/Microsoft\ VS\ Code/bin/code"

# windows terminal
alias windows.terminal.config="nvim $WINDOWS_APPDATA/Local/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json"
