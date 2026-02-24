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

# clean pycache
pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}

# refactor
_py.format.convert-string-quote() {
    local quote="$1"
    shift
    ruff check --select Q \
        --config "lint.flake8-quotes.inline-quotes='$quote'" \
        --config "lint.flake8-quotes.docstring-quotes='$quote'" "$@"
}
py.format.use-single-quote-string() { _py.format.convert-string-quote single "$@" }
py.format.use-double-quote-string() { _py.format.convert-string-quote double "$@" }
py.cleanup.remove-unused-import() {
    ruff check --select F401 "$@"
}
_py.refactor() {
    local module="$1"
    shift
    PYTHONPATH="$HOME/.config/zshrc/utils/python:$PYTHONPATH" \
    uv run --no-project --python=3.14t \
        --with=typer --with=libcst --with=pathspec --with=ruff --with=pudb \
        -m "$module" "$@"
}
py.refactor.abs-to-rel() { _py.refactor refactor.abs_to_rel "$@" }
py.refactor.rel-to-abs() { _py.refactor refactor.rel_to_abs "$@" }

