installed wivrn-dashboard || return


wivrn.status() {
    # check for active established tcp connections on either 9757 (wifi) or 19757 (wired)
    local active_conn=$(ss -H -t state established 'sport = :9757 or dport = :9757 or sport = :19757 or dport = :19757')

    # no active established session
    if [[ -z "$active_conn" ]]; then
        echo "${RED}Disconnected${RESET}"
        return 1
    fi

    # check port used in active socket output
    local port="9757"
    if echo "$active_conn" | grep -q '19757'; then
        port="19757"
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
