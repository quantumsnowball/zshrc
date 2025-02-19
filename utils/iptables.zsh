ensure iptables || return


# READ
iptables.filter = () {
    sudo iptables -vL --line-numbers | less -c -S -F
}
iptables.filter.input = () {
    sudo iptables -vL INPUT --line-numbers | less -c -S -F
}
iptables.filter.forward = () {
    sudo iptables -vL FORWARD --line-numbers | less -c -S -F
}
iptables.filter.output = () {
    sudo iptables -vL OUTPUT --line-numbers | less -c -S -F
}
__ip_tables_current () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers ; echo
    sudo iptables -L FORWARD --line-numbers ; echo
    sudo iptables -L OUTPUT --line-numbers ; echo
}
__ip_tables_input_current () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers ; echo
}


# ADD
__ip_tables_input_open_ports () {
    sudo iptables -I INPUT 1 -p $1 --dport $2 -j ACCEPT &&
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
iptables.filter.input.open-tcp-ports () {
    __ip_tables_input_current
    echo -n "${CYAN}TCP port or range of ports to allow: ${RESET}" ; read dport ; echo ""
    __ip_tables_input_open_ports tcp $dport
}
iptables.filter.input.open-udp-ports () {
    __ip_tables_input_current
    echo -n "${CYAN}UDP port or range of ports to allow: ${RESET}" ; read dport ; echo ""
    __ip_tables_input_open_ports udp $dport
}


# DELETE
iptables.filter.delete-filter () {
    __ip_tables_current
    echo -n "${CYAN}Select a table [INPUT/FORWARD/OUTPUT]: ${RESET}" ; read name
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo ""
    sudo iptables -D $name $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
iptables.filter.input.delete-filter () {
    __ip_tables_input_current
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo ""
    sudo iptables -D INPUT $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
