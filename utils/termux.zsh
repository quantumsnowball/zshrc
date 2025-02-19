[ -v TERMUX_VERSION ] || return


# some Termux common command listed here
alias tm.wake='termux-wake-lock'
alias tm.unwake='termux-wake-unlock'
alias tm.setup-storage='termux-setup-storage'
tm.theme () {
    installed termux-style &&
        termux-style ||
        echo "Please installed termux-style at:\nhttps://github.com/adi1090x/termux-style"
}
