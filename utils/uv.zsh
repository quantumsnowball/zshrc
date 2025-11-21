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

# disk usage
uv.disk-usage () {
    uv run $HOME/.config/zshrc/utils/_lib/uv.disk-usage.py
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
