ensure man || return


# NOTE:
# Linux usually use mandb but Termux follow FreeBSD using mandoc

# envs
ensure bat && export MANPAGER="sh -c 'col -bx | bat -l man -p --wrap=never'"
export MANROFFOPT="-c"


# quick fix for termux manpager using bat
# ref: https://github.com/sharkdp/bat/issues/1517                                │
if [[ -v TERMUX_VERSION ]]; then
    man() {
        command man -O "width=$COLUMNS" "$@" | eval ${MANPAGER}
    }
fi

