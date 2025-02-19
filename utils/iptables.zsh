ensure iptables || return


# Written and tested on CentOS 7
ip.tables = () {
    sudo iptables -vL --line-numbers | 
        cut -f -9 | 
        column -t | 
        sed 's/^Chain/\n&/g' | 
        sed '/^Chain/ s/[ \t]\{1,\}/ /g' | 
        sed '/^[0-9]/ s/[ \t]\{1,\}/ /10g' | 
        bat --wrap=never --style=grid --color=always
}

ip.tables.input = () {
    sudo iptables -vL INPUT --line-numbers
}
ip.tables.input.delete-line () {
    ip.tables.input
    echo -n "\nLine number to be deleted: " ; read line ; echo ""
    sudo iptables -D INPUT $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}

ip.tables.forward = () {
    sudo iptables -vL FORWARD --line-numbers
}

ip.tables.output = () {
    sudo iptables -vL OUTPUT --line-numbers
}
