installed wivrn-dashboard || return


wivrn.status() {
    local PORT_WIFI=9757
    local PORT_USB=19757

    # check for active established tcp connections on either port
    local active_conn=$(ss -H -t state established "sport = :${PORT_WIFI} or dport = :${PORT_WIFI} or sport = :${PORT_USB} or dport = :${PORT_USB}")

    # no active established session
    if [[ -z "$active_conn" ]]; then
        echo "${RED}Disconnected${RESET}"
        return 1
    fi

    # check port used in active socket output
    local port="$PORT_WIFI"
    if echo "$active_conn" | grep -q "$PORT_USB"; then
        port="$PORT_USB"
    fi

    # check transport type
    if echo "$active_conn" | grep -qE '127\.0\.0\.1'; then
        echo "${GREEN}Connected: Wired (USB) [Port: ${port}]${RESET}"
    else
        echo "${CYAN}Connected: Wireless (WiFi) [Port: ${port}]${RESET}"
    fi
}

wivrn.on-WiFi() {
    # default port on 9757
    wivrn-dashboard
}
wivrn.on-USB() {
    # default port on 19757
    wivrn-custom-port 19757
}
