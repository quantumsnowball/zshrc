ensure uv || return


# list python
alias uv.python.list-installed-versions='uv python list'
alias uvpyls=uv.python.ls

# global tools
source "$XDG_CONFIG_HOME/zshrc/utils/uv/tool.zsh"

# upgrade python version
alias uv.python.list-current-versions='uv.venv-info'
alias uv.python.upgrade.for-all-tool='uv tool upgrade --all --python'
uv.python.upgrade.for-user-venv() {
    local venv_name="$1"
    local python_version="$2"
    local venv_path="$HOME/.uv/venv/$venv_name"
    if [[ -z "$venv_name" || -z "$python_version" ]]; then
        echo "Usage: uv.python.upgrade.user-venv <env name> <version>"
        return 1
    fi
    if [[ ! -d "$venv_path" ]]; then
        echo "Error: Environment $venv_path not found."
        return 1
    fi
    uv venv $venv_path --python $python_version --allow-existing
}

# uninstall
alias uv.python.uninstall-version='uv python uninstall'

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
