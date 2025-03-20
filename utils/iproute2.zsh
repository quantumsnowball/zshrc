ensure ip || return




ip.local.link () { 
    ip -c -br link; 
}
alias lslink=ip.local.link
alias lsnic=ip.local.link

ip.local.addr () {
    ip -c -br addr || ifconfig.local.addr
}
alias lsip=ip.local.addr
alias myip=ip.local.addr

ip.local.addr4 () {
    ip -c -br -4 addr || ifconfig.local.addr
}
alias lsip4=ip.local.addr4
alias myip4=ip.local.addr4

ip.local.addr6 () {
    ip -c -br -6 addr
}
alias lsip6=ip.local.addr6
alias myip6=ip.local.addr6

ip.routing-table () {
    ip -c route; 
}
alias lsroute=ip.routing-table
alias ip.route=ip.routing-table

ip.default-gateway.ipv4 () {
    ip -4 route show default
}
ip.default-gateway.ipv6 () {
    ip -6 route show default
}
ip.default-gateway () {
    ip.default-gateway.ipv4
    ip.default-gateway.ipv6
}
