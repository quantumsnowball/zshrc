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
