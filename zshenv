# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# path
# NOTE: on Arch, ~/.config/environment.d/*.conf failed to set PATH, probably due to
# PATH being hardcode and overwritten afterward, there have to set it here for login shell
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
