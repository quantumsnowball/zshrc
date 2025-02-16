ensure curl || return


# query public ip address as seen from Internet
lsip4.pub () {
    curl -s -4 ifconfig.me | grep -v '^$'
}
lsip6.pub () {
    curl -s -6 ifconfig.me | grep -v '^$'
}
lsip.pub () {
    lsip4.pub
    lsip6.pub
}
