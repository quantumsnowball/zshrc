wtf()
{
    echo -e "\n>_ ${GREEN}command -v${RESET} ${BLUE}$1${RESET}"
    command -v $1

    echo -e "\n>_ ${GREEN}type -a${RESET} ${BLUE}$1${RESET}"
    type -a $1

    echo -e "\n>_ ${GREEN}whatis${RESET} ${BLUE}$1${RESET}"
    whatis $1

    echo -e "\n"
}
