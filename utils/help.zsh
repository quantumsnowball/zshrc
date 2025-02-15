wtf()
{
    # Define color escape sequences
    G="\033[32m"
    B="\033[34m"
    rs="\033[0m"

    echo -e "\n>_ ${G}command -v${rs} ${B}$1${rs}"
    command -v $1

    echo -e "\n>_ ${G}type -a${rs} ${B}$1${rs}"
    type -a $1

    echo -e "\n>_ ${G}whatis${rs} ${B}$1${rs}"
    whatis $1

    echo -e "\n"
}
