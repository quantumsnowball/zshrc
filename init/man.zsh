# quick fix for termux manpager using bat
# ref: https://github.com/sharkdp/bat/issues/1517                                │
if [[ -v TERMUX_VERSION ]]; then
    man() {
        command man "$@" | eval ${MANPAGER}
    }
fi

