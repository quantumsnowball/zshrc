[ -v TERMUX_VERSION ] || return


# some Termux common command listed here
alias termux.wake='termux-wake-lock'
alias termux.unwake='termux-wake-unlock'
alias termux.setup-storage='termux-setup-storage'
termux.theme () {
    installed termux-style &&
        termux-style ||
        echo "Please installed termux-style at:\nhttps://github.com/adi1090x/termux-style"
}


# nerd fonts
termux.use-font() {
    dst="$HOME/.termux/font.ttf"
    ln -srf "$1" "$dst"
    termux-reload-settings
}
