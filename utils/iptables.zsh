ensure iptables || return


# READ
ip.tables = () {
    sudo iptables -vL --line-numbers | less -c -S -F
}
ip.tables.input = () {
    sudo iptables -vL INPUT --line-numbers | less -c -S -F
}
ip.tables.forward = () {
    sudo iptables -vL FORWARD --line-numbers | less -c -S -F
}
ip.tables.output = () {
    sudo iptables -vL OUTPUT --line-numbers | less -c -S -F
}

# DELETE
ip.tables.delete-filter () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers
    sudo iptables -L FORWARD --line-numbers
    sudo iptables -L OUTPUT --line-numbers
    echo -n "${CYAN}Select a table [INPUT/FORWARD/OUTPUT]: ${RESET}" ; read name
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo ""
    sudo iptables -D $name $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
ip.tables.input.delete-filter () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo ""
    sudo iptables -D INPUT $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
