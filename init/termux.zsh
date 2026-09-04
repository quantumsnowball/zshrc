[ -v TERMUX_VERSION ] || return


# run in background and disown, avoid slowing down shell launch
(termux-wake-lock >/dev/null 2>&1 &!)
