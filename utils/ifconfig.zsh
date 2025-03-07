ensure ifconfig || return


ifconfig.local.addr () {
    ifconfig | awk -v cyan="$CYAN" -v green="$GREEN" -v red="$RED" -v reset="$RESET" '
    /^[a-zA-Z0-9]/ { iface=$1; sub(/:/, "", iface) }
    /inet / { print cyan iface reset, green $2 reset, red $4 reset }
    ' | column -t
}
