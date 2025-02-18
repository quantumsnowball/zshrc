ensure curl || return


# query public ip address as seen from Internet
ip.public.ls-addr4 () {
    curl -s -4 ifconfig.me | grep -v '^$'
}
alias lsip4.pub=ip.public.ls-addr4

ip.public.ls-addr6 () {
    curl -s -6 ifconfig.me | grep -v '^$'
}
alias lsip6.pub=ip.public.ls-addr6

ip.public.ls-addr () {
    ip.public.ls-addr4
    ip.public.ls-addr6
}
alias lsip.pub=ip.public.ls-addr




