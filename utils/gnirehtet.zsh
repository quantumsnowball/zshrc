# generic helper on the client side
gnirehtet.test-connection() {
    # ping test
    ping -c 2 10.0.0.2
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
