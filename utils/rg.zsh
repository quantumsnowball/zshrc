ensure rg || return


rg.less () {
    rg \
        --color=always \
        --heading \
        --colors='path:fg:yellow' \
        "$1" | 
    less \
        --clear-screen \
        --chop-long-line \
        --RAW-CONTROL-CHARS \
        --LINE-NUMBERS \
        --tilde \
        --use-color \
        --color=Nk \
}
