ensure rg || return


rg.less () {
    rg \
        --color=always \
        --heading \
        --colors='path:fg:yellow' \
        "$@" | 
    less \
        --clear-screen \
        --chop-long-line \
        --RAW-CONTROL-CHARS \
        --LINE-NUMBERS \
        --tilde \
        --use-color \
        --color=Nk \
}
alias rg.hidden.less='rg.less --hidden'

# context
() {
    # common multiples
    local n
    for n (01 02 04 08 16 32 64); do
        alias rg.context.${n}-lines="rg -C${n}"
        alias rg.context.${n}-lines.before="rg -B${n}"
        alias rg.context.${n}-lines.after="rg -A${n}"
    done
}
