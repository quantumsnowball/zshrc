# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# Define colors
export BLACK="\033[0;30m"    # black
export RED="\033[0;31m"      # red
export GREEN="\033[0;32m"    # green
export YELLOW="\033[0;33m"   # yellow
export BLUE="\033[0;34m"     # blue
export MAGENTA="\033[0;35m"  # magenta
export CYAN="\033[0;36m"     # cyan
export WHITE="\033[0;37m"    # white
export RESET="\033[0m"       #

# path
# NOTE: on Arch, ~/.config/environment.d/*.conf failed to set PATH, probably due to
# PATH being hardcode and overwritten afterward, there have to set it here for login shell
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
