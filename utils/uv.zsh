ensure uv || return


# list python
alias uv.python.list='uv python list'
alias uvpyls=uv.python.list

# list global tools
alias uv.tool.list='uv tool list --show-version-specifiers --show-with --show-extras --show-python'
alias uvtoolls=uv.tool.list

# venv
uv.venv.activate-local () {
    if [[ -f ./.venv/bin/activate ]]; then
        . ./.venv/bin/activate
    else
        echo "Error: ./.venv/bin/activate not found. No virtual environment activated."
    fi
}

# cache management
alias uv.cache.prune='uv cache prune'
uv.disk-usage () {
    uv run $HOME/.config/zshrc/utils/_lib/uv.disk-usage.py
}
uv.trace-hardlink() {
    (( $# == 1 )) || { echo "Usage: uv.trace-hardlink <path-to-file-in-uv-cache>" && return 1 }
    # args
    local file="$1"
    [[ -f "$file" ]] || { echo "File not found: $file" && return 1 }
    # check inode
    local inode=$(stat -c %i -- "$file")
    echo "inode: $inode"
    # locate the same inode
    find \
        $HOME/.cache/uv \
        $HOME/.local/share/uv/tools \
        $HOME/.uv/venv \
        $HOME/repos \
        -type f -links +1 -inum $inode
}

# uv pip install basic
uv.pip.install-basic()
{
# general
uv pip install \
    click typer \
    rich colorama \
    ipython jupyter pytest
# numeric
uv pip install \
    numpy scipy pandas
# charting
uv pip install \
    matplotlib
# networking
uv pip install \
    requests aiohttp
# linting
uv pip install \
    mypy isort autopep8
# debug
uv pip install \
    pudb debugpy
}
