#
# ~/.zshenv runs for all four scenario
# interactive/non-interactive login
# 1. interactive login
#   SDDM desktop session, SSH
# 2. interactive non-login
#   Kitty, Alacritty, Konsole
# 3. non-interactive login
#   SSH direct run command on remote
# 4. non-interactive non-login
#   when program call a shell to run a script
#
# Reference:
# https://github.com/sambacha/dotfiles2
#

# editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# path
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
