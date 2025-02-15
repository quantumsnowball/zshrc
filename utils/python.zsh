ensure python || return


# python
alias py=python
alias ipy=ipython
alias ptpy=ptpython
alias ptipy=ptipython


pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}
