ensure curl || return


# query public ip address as seen from Internet
ip.public.addr4 () {
    curl -s -4 ifconfig.me | grep -v '^$'
}
alias lsip4.pub=ip.public.addr4
alias myip4.pub=ip.public.addr4

ip.public.addr6 () {
    curl -s -6 ifconfig.me | grep -v '^$'
}
alias lsip6.pub=ip.public.addr6
alias myip6.pub=ip.public.addr6

ip.public.addr () {
    ip.public.addr4
    ip.public.addr6
}
alias lsip.pub=ip.public.addr
alias myip.pub=ip.public.addr

ip.public.where-am-i () {
    installed jq && 
        curl -s ipinfo.io | jq ||
        curl -s ipinfo.io
}
alias whereami=ip.public.where-am-i

