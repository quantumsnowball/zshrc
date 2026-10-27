# uv pip
alias uv.pip.ls='uv pip list'
alias uv.pipls=uv.pip.ls
alias uv.pip.ls-grep='uv pip list | rg'
alias uv.piprg=uv.pip.ls-grep
alias uv.pip.install='uv pip install'
alias uv.pipi=uv.pip.install
alias uv.pip.install.editable='uv pip install -e'
alias uv.pipi.e=uv.pip.install.editable
alias uv.pip.remove='uv pip uninstall'
alias uv.piprm=uv.pip.remove
alias uv.pip.update='uv pip list --outdated'
alias uv.pipu=uv.pip.update
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

