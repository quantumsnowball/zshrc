installed wivrn-dashboard || return


wivrn.status() {
    # check for active established tcp connections on port 9757
    local active_conn=$(ss -H -t state established 'sport = :9757 or dport = :9757')

    # no active established session
    if [[ -z "$active_conn" ]]; then
        echo "${RED}Disconnected${RESET}"
        return 1
    fi

    # check if the peer/local endpoint uses 127.0.0.1 (adb loopback)
    if echo "$active_conn" | grep -q '127.0.0.1'; then
        echo "${GREEN}Connected: Wired (USB adb)${RESET}"
    else
        echo "${CYAN}Connected: Wireless (WiFi)${RESET}"
    fi
}
