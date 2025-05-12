ensure rg || return


rg.less () {
    rg \
        --color=always \
        --heading \
        --colors='path:fg:yellow' \
        "$1" | 
    # c - clear screen
    # S - no wrap
    # R - raw char with color
    # N - print line number
    less -cSRN
}
