ensure ip || return


_ip-addr-pretty-print() {
    awk '{
        printf "%-22s%s", $1, $2;  # Print interface and state
        if (NF > 2) {
            printf "\n"
            for (i = 3; i < NF; i++) {
                printf "    %s\n", $i;  # Indent each address with 4 spaces
            }
        }
    }'
}

ip.local.link () { 
    ip -c -br link; 
}
alias lslink=ip.local.link
alias lsnic=ip.local.link

ip.local.addr () {
    ip -c -br addr | _ip-addr-pretty-print || ifconfig.local.addr
}
alias lsip=ip.local.addr
alias myip=ip.local.addr

ip.local.addr4 () {
    ip -c -br -4 addr | _ip-addr-pretty-print || ifconfig.local.addr
}
alias lsip4=ip.local.addr4
alias myip4=ip.local.addr4

ip.local.addr6 () {
    ip -c -br -6 addr | _ip-addr-pretty-print
}
alias lsip6=ip.local.addr6
alias myip6=ip.local.addr6

ip.routing-table () {
    ip -c route; 
}
alias lsroute=ip.routing-table
alias ip.route=ip.routing-table

ip.default-gateway.ipv4 () {
    ip -c -4 route show default
}
ip.default-gateway.ipv6 () {
    ip -c -6 route show default
}
ip.default-gateway () {
    ip.default-gateway.ipv4
    ip.default-gateway.ipv6
}
