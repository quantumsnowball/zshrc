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
termux.nerd-fonts.hack () {
    wget 'https://docs.google.com/uc?export=download&id=1OnxTvByrp24-qfW-4-lJDLZ2tvVOhfZT' -O ~/.termux/font.ttf
}
termux.nerd-fonts.hack-mono () {
    wget 'https://docs.google.com/uc?export=download&id=1cvetA3bgOCiXWoEhoAQevgkvvvbxBsiy' -O ~/.termux/font.ttf
}
termux.nerd-fonts.meslo () {
    wget 'https://docs.google.com/uc?export=download&id=1DUikjuAWKLS2zbt_ZysNLKwyv9SgywAZ' -O ~/.termux/font.ttf
}
termux.nerd-fonts.meslo-mono () {
    wget 'https://docs.google.com/uc?export=download&id=1SQaqY3mRqrF897D2_RIur43hADURilNw' -O ~/.termux/font.ttf
}
