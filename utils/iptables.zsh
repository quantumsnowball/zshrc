ensure iptables || return


_iptables-pretty-printer () {
    # store iptables stdout into a var
    raw_input=$(cat)

    # split each tables content by newlines
    (){
        # IFS is Internal Filed Separator, shell uses it to split words
        # set it as local within anomynous function to avoid pollution
        local IFS=$'\x1F'
        chains=($(echo -n "$raw_input" | sed 's/^$/\x1F/'))
    }
    # remove leading newline
    chains=("${chains[@]#$'\n'}")
    # remove trailing newline
    chains=("${chains[@]%$'\n'}")

    echo $#chains
    for chain in "${chains[@]}"; do
        echo '<table>':
        echo $chain
    done
    # echo "$raw_input"
    # make tabular (table) output
    # column -t |
    # sed 's/^Chain/\n&/g' |
    # sed '/^Chain/ s/[ \t]\{1,\}/ /g' |
    # sed '/^[0-9]/ s/[ \t]\{1,\}/ /10g' |
    # # pager
    # less -c -S
}

# READ
iptables.filter = () {
    # sudo iptables -v -L --line-numbers
    sudo iptables -v -L --line-numbers | _iptables-pretty-printer
}
iptables.filter.input = () {
    sudo iptables -v -L INPUT --line-numbers | less -c -S
}
iptables.filter.forward = () {
    sudo iptables -v -L FORWARD --line-numbers | less -c -S
}
iptables.filter.output = () {
    sudo iptables -v -L OUTPUT --line-numbers | less -c -S
}
__print_filter () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers ; echo
    sudo iptables -L FORWARD --line-numbers ; echo
    sudo iptables -L OUTPUT --line-numbers ; echo
}
__print_input_filter () {
    echo "${YELLOW}Current filter rules:${RESET}"
    sudo iptables -L INPUT --line-numbers ; echo
}
iptables.nat = () { 
    sudo iptables -t nat -v -L --line-numbers | less -c -S
}
iptables.mangle = () { 
    sudo iptables -t mangle -v -L --line-numbers | less -c -S
}
iptables.raw = () { 
    sudo iptables -t raw -v -L --line-numbers | less -c -S
}
iptables.security = () { 
    sudo iptables -t security -v -L --line-numbers | less -c -S
}


# ADD
__input_filter_accept_ports () {
    sudo iptables -I INPUT 1 -p $1 --dport $2 -m comment --comment $3 -j ACCEPT &&
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
iptables.filter.input.open-tcp-ports () {
    __print_input_filter
    echo -n "${CYAN}TCP port or range of ports to allow: ${RESET}" ; read dport
    echo -n "${CYAN}Enter comment or remarks: ${RESET}" ; read comment ; echo
    __input_filter_accept_ports tcp $dport $comment
}
iptables.filter.input.open-udp-ports () {
    __print_input_filter
    echo -n "${CYAN}UDP port or range of ports to allow: ${RESET}" ; read dport
    echo -n "${CYAN}Enter comment or remarks: ${RESET}" ; read comment ; echo
    __input_filter_accept_ports udp $dport $comment
}


# DELETE
iptables.filter.delete-filter () {
    __print_filter
    echo -n "${CYAN}Select a table [INPUT/FORWARD/OUTPUT]: ${RESET}" ; read name
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo
    sudo iptables -D $name $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
iptables.filter.input.delete-filter () {
    __print_input_filter
    echo -n "${CYAN}Line number to be deleted: ${RESET}" ; read line ; echo
    sudo iptables -D INPUT $line && 
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
