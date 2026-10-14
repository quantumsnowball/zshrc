ensure adb || return


usb0.device() {
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

usb0.connect() {
    # ensure only one device connected
    usb0.device || return 1

    # enable the usb link layer device
    sleep 1 &&
    adb shell svc usb setFunctions ncm && echo "\n${GREEN}Enabled the usb link layer device${RESET}" &&
    sleep 1 &&
    echo "\nHost link layer status:" && ip -br link &&
    sleep 1 &&
    echo "\nClient link layer status:" && adb shell ip -br link

    # extract host new usb interface name
    # TODO

    # ensure ufw allow all incoming network traffics for this interface
    # TODO

    # assign an ip address to the server side
    sudo ip addr flush dev enp60s0u1i3
    sudo ip addr add 10.77.0.1/24 dev enp60s0u1i3
    sudo ip link set enp60s0u1i3 up
    ip -4 addr show dev enp60s0u1i3

    # assign an ip address to the client side
    # TODO: the example use dnsmasq to make a dhcp server, but can i simplified it
    # TODO: can I just request a fixed ip addr of 10.77.0.2 always?

    # confirm the client ip is acquired successfully
    adb shell ip -4 addr show dev usb0
    adb shell ip -4 route show dev usb0

    # test the usb connection
    adb shell ping -c 3 -I usb0 10.77.0.1

    # disable the client's wifi
    adb shell svc wifi disable
}
