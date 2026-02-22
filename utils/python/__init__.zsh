ensure python || return


# python
alias py=python
alias ipy=ipython
alias ptpy=ptpython
alias ptipy=ptipython

# debugger
alias py.debug.pdb='python -m pdb'
alias py.debug.pudb='python -m pudb'
alias pyd=py.debug.pudb

# breakpoint() use pudb
export PYTHONBREAKPOINT=pudb.set_trace

# clean pycache
pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}

# refactor
py.format.use-single-quote-string() {
    ruff check --select Q --fix \
        --config "lint.flake8-quotes.inline-quotes='single'" \
        --config "lint.flake8-quotes.docstring-quotes='single'" "$@"
}
py.refactor.remove-unused-import() {
    ruff check --select F401 --fix "$@"
}

alias py.refactor.abs-to-rel="uv run --no-project --with=libcst --with=pudb $HOME/.config/zshrc/utils/python/refactor_utils/abs_to_rel.py"

