# python
alias py=ptpython
alias ipy=ptipython

pyclean () {
    find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete
}
