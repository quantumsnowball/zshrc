ensure iptables || return


# READ
ip.tables = () {
    sudo iptables -vL --line-numbers | less -c -S -F
}

ip.tables.input = () {
    sudo iptables -vL INPUT --line-numbers | less -c -S -F
}
ip.tables.input.delete-line () {
    ip.tables.input
    echo -n "\nLine number to be deleted: " ; read line ; echo ""
    sudo iptables -D INPUT $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}

ip.tables.forward = () {
    sudo iptables -vL FORWARD --line-numbers | less -c -S -F
}

ip.tables.output = () {
    sudo iptables -vL OUTPUT --line-numbers | less -c -S -F
}
