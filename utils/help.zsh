# a basic helper to ask what a command is
wtf() {
    echo -e "\n>_ ${GREEN}command -v${RESET} ${BLUE}$1${RESET}"
    command -v $1

    echo -e "\n>_ ${GREEN}type -a${RESET} ${BLUE}$1${RESET}"
    type -a $1

    echo -e "\n>_ ${GREEN}whatis${RESET} ${BLUE}$1${RESET}"
    whatis $1

    echo -e "\n"
}


# a more detailed version of wtf which can also show the content of a function
wtf.in() {
    echo -e "\n>_ ${GREEN}type -a${RESET} ${BLUE}$1${RESET}"
    type -a $1

    installed which || return

    echo -e "\n>_ ${GREEN}which${RESET} ${BLUE}$1${RESET}"
    which $1
}
alias wtfin='wtf.in'

# diagnostics
alias wtf.is-wrong.dmesg='dmesg'
alias wtf.is-wrong.journalctl='journalctl -xe'
