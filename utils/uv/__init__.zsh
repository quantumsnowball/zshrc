ensure uv || return


# global tools
source "$XDG_CONFIG_HOME/zshrc/utils/uv/tool.zsh"

# upgrade python version
source "$XDG_CONFIG_HOME/zshrc/utils/uv/python.zsh"

# venv
uv.venv.activate-local () {
    if [[ -f ./.venv/bin/activate ]]; then
        . ./.venv/bin/activate
    else
        echo "Error: ./.venv/bin/activate not found. No virtual environment activated."
    fi
}
alias uv.venv.ls='uv.venv-info'

# cache management
source "$XDG_CONFIG_HOME/zshrc/utils/uv/cache.zsh"

# uv pip
source "$XDG_CONFIG_HOME/zshrc/utils/uv/pip.zsh"
