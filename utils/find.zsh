ensure find || return


find.less () {
    find . -name "$@" |
    less \
        --clear-screen \
        --chop-long-line \
        --RAW-CONTROL-CHARS \
        --LINE-NUMBERS \
        --tilde \
        --use-color \
        --color=Nk \
}
