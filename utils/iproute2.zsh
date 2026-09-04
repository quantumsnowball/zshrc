ensure ip || return


ip.local.link () { 
    ip -c -br link; 
}
ip.local.addr () {
    ip -c -br addr || ifconfig.local.addr
}
ip.local.addr4 () {
    ip -c -br -4 addr || ifconfig.local.addr
}
ip.local.addr6 () {
    ip -c -br -6 addr
}
ip.routing-table () {
    ip -c route; 
}
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

() {
    # namespaces
    local ns=(ip net network nic if route gateway sys os)

    alias ${^ns}.local.link='ip.local.link'
    alias ${^ns}.local.addr='ip.local.addr'          
    alias ${^ns}.local.addr4='ip.local.addr4'         
    alias ${^ns}.local.addr6='ip.local.addr6'         
    alias ${^ns}.routing-table='ip.routing-table'       
    alias ${^ns}.default-gateway.ipv4='ip.default-gateway.ipv4'
    alias ${^ns}.default-gateway.ipv6='ip.default-gateway.ipv6'
    alias ${^ns}.default-gateway='ip.default-gateway'     
}

