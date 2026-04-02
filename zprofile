# editor
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim

# path
if [[ -d "$HOME/.local/bin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
