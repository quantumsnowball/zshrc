ensure curl || return


# query public ip address as seen from Internet
ip.public.addr4 () {
    curl -s -4 ifconfig.me | grep -v '^$'
}
ip.public.addr6 () {
    curl -s -6 ifconfig.me | grep -v '^$'
}
ip.public.addr () {
    ip.public.addr4
    ip.public.addr6
}
ip.public.where-am-i () {
    installed jq && 
        curl -s ipinfo.io | jq ||
        curl -s ipinfo.io
}

() {
    # namespaces
    local ns=(ip net network nic if route gateway sys os)

    alias ${^ns}.public.addr4='ip.public.addr4'
    alias ${^ns}.public.addr6='ip.public.addr6'
    alias ${^ns}.public.addr='ip.public.addr'
    alias ${^ns}.public.where-am-i='ip.public.where-am-i'
}
