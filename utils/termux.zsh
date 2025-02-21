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


# nerd fonts
tm.nerd-fonts.hack () {
    wget 'https://docs.google.com/uc?export=download&id=1OnxTvByrp24-qfW-4-lJDLZ2tvVOhfZT' -O ~/.termux/font.ttf
}
tm.nerd-fonts.hack-mono () {
    wget 'https://docs.google.com/uc?export=download&id=1cvetA3bgOCiXWoEhoAQevgkvvvbxBsiy' -O ~/.termux/font.ttf
}
tm.nerd-fonts.meslo () {
    wget 'https://docs.google.com/uc?export=download&id=1DUikjuAWKLS2zbt_ZysNLKwyv9SgywAZ' -O ~/.termux/font.ttf
}
tm.nerd-fonts.meslo-mono () {
    wget 'https://docs.google.com/uc?export=download&id=1SQaqY3mRqrF897D2_RIur43hADURilNw' -O ~/.termux/font.ttf
}
