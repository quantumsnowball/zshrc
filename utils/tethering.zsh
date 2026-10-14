ensure adb || return


tethering.device() {
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

tethering.connect() {
    # ensure only one device connected
    tethering.device || return 1

    # enable the usb link layer device
    sleep 1 &&
    adb shell svc usb setFunctions ncm && echo "\n${GREEN}Enabled the usb link layer device${RESET}" &&
    sleep 1 &&
    echo "\nHost link layer status:" && ip -br link &&
    sleep 1 &&
    echo "\nClient link layer status:" && adb shell ip -br link

    # extract host new usb interface name
    local host_iface
    host_iface=$(ip -br link show | awk '$1 ~ /^enp0/ || $1 ~ /^usb/ {print $1}' | tail -n 1)

    [[ -n "$host_iface" ]] || { echo "failed to detect host usb interface"; return 1; }
    echo "\nDetected host interface: $host_iface"

    # ensure ufw allow all incoming network traffics for this interface
    sleep 1 &&
    sudo ufw allow in on "$host_iface" comment "android usb-ncm"

    # assign an ip address to the server side
    sudo ip addr flush dev "$host_iface" &&
    sudo ip addr add 10.77.0.1/24 dev "$host_iface" &&
    sudo ip link set "$host_iface" up &&
    ip -4 addr show dev "$host_iface" &&

    # start a dhcp server on the host and let
    # note: ip addr through rtnetlink gives permissio error, so impossible to set fixed ip here
    sleep 1 &&
    sudo dnsmasq \
        --no-daemon \
        --log-dhcp \
        --port=0 \
        --interface="$host_iface" \
        --bind-interfaces \
        --dhcp-authoritative \
        --dhcp-range=10.77.0.2,10.77.0.2,255.255.255.0,24h \
        &
    dnsmasq_pid=$!

    # make the android client request an ip through dhcp
    sleep 1 &&
    adb shell cmd ethernet set-ip-configuration usb0 dhcp

    # confirm the client ip is acquired successfully
    sleep 1 &&
    adb shell ip -4 addr show dev usb0 &&
    sleep 1 &&
    adb shell ip -4 route show dev usb0

    # test the usb connection
    sleep 1 &&
    adb shell ping -c 3 -I usb0 10.77.0.1

    # disable the client's wifi
    sleep 1 &&
    adb shell svc wifi disable

    # safely kill the dhcp server
    sleep 1 &&
    sudo kill $dnsmasq_pid
}
