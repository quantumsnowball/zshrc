ifconfig.local.addr () {
    ifconfig | awk '
    /^[a-zA-Z0-9]/ { iface=$1 }
    /inet / { print iface, $2, $4 }
    ' | column -t
}
