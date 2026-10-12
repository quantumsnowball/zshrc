# generic helper on the client side
gnirehtet.test-connection() {
    # ping test tunnel
    ping -c 2 10.0.0.2

    # curl test the host-only sunshine admin web server
    curl -v -kI https://10.0.2.2:47990
}

# needs adb
ensure adb || return


gnirehtet.device() {
    local dev_list=($(adb devices | grep -w "device"))

    if ((${#dev_list} == 0)); then
        echo "${RED}Error: No authorized adb device connected${RESET}" >&2
        return 1
    elif ((${#dev_list} > 2)); then
        echo "${RED}Error: Multiple adb devices connected${RESET}" >&2
        return 1
    fi

    echo "${GREEN}Active connected device: ${dev_list[1]}${RESET}"
}
# needs functions
# needs gnirehtet
ensure gnirehtet || return


gnirehtet.connect() {
    # guard
    gnirehtet.device || return 1

    # run
    gnirehtet run
}

gnirehtet.connect.quest2()  {
    # quest2 only need a simple connect
    gnirehtet.connect
}

gnirehtet.connect.s7() {
    # run gnirehtet normally
    gnirehtet.connect

    # TODO: restore the original vpn here
    # gnirehtet.restore-wireguard-vpn
}
