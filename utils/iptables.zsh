ensure iptables || return


_iptables-pretty-print () { 
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

    for chain in "${chains[@]}"; do
        # print the first line as title
        echo "$CYAN$(echo $chain | sed -n '1p')$RESET"

        # extract the second line and below as content
        # - select second down to the last line
        # - pipe into column
        # - removes excessive spaces
        content=$(
            echo $chain | 
            sed -n '2,$p' |
            column -t |
            sed '/^[0-9]/ s/[ \t]\{1,\}/ /11g'
        )

        # print the table headers
        echo "$YELLOW$(echo $content | sed -n '1p')$RESET"

        # print the table rows
        echo $content | sed -n '2,$p'

        # new lines after each table
        echo ''
    done 
    # display in pager less with color support
}

_iptables-pager () {
    [[ $1 == "-r" || $1 == "--raw" ]] && 
        less -c -S -R ||
        _iptables-pretty-print | less -c -S -R
}

# READ
iptables.filter = () {
    sudo iptables -v -L --line-numbers | _iptables-pager $1
}
iptables.filter.input = () {
    sudo iptables -v -L INPUT --line-numbers | _iptables-pager $1
}
iptables.filter.forward = () {
    sudo iptables -v -L FORWARD --line-numbers | _iptables-pager $1
}
iptables.filter.output = () {
    sudo iptables -v -L OUTPUT --line-numbers | _iptables-pager $1
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
    sudo iptables -t nat -v -L --line-numbers | _iptables-pager $1
}
iptables.mangle = () { 
    sudo iptables -t mangle -v -L --line-numbers | _iptables-pager $1
}
iptables.raw = () { 
    sudo iptables -t raw -v -L --line-numbers | _iptables-pager $1
}
iptables.security = () { 
    sudo iptables -t security -v -L --line-numbers | _iptables-pager $1
}


# ADD
__input_filter_accept_ports () {
    sudo iptables -I INPUT 1 -p $1 --dport $2 -m comment --comment $3 -j ACCEPT &&
        echo "\nResult: ${GREEN}SUCCESS${RESET}\n" || 
        echo "\nResult: ${RED}FAILED${RESET}\n"
}
iptables.filter.input.open-tcp-ports () {
    [ -z "$1" ] && [ -z "$2" ] && __print_input_filter
    [ -n "$1" ] && dport=$1   || { echo -n "${CYAN}TCP port or range of ports to allow: ${RESET}" ; read dport }
    [ -n "$2" ] && comment=$2 || { echo -n "${CYAN}Enter comment or remarks: ${RESET}" ; read comment ; echo }
    __input_filter_accept_ports tcp $dport $comment
}
iptables.filter.input.open-udp-ports () {
    [ -z "$1" ] && [ -z "$2" ] && __print_input_filter
    [ -n "$1" ] && dport=$1   || { echo -n "${CYAN}UDP port or range of ports to allow: ${RESET}" ; read dport }
    [ -n "$2" ] && comment=$2 || { echo -n "${CYAN}Enter comment or remarks: ${RESET}" ; read comment ; echo }
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
