ensure adb || return


tethering.device() {
    adb kill-server

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

tethering.info() {
    echo "Host IP address status:"
    ip -4 addr show

    echo "\nClient IP address status:"
    adb shell ip -4 addr show dev usb0 ||
    adb shell ip -4 addr show dev rndis0
}

tethering.connect-quest2() {
    # special thanks to this tutorial:
    # <https://blog.ronbachmann.dev/posts/quest3-usb-ncm-sunshine>

    # get root permission first
    sudo -v || { echo "${RED}Failed to get root permission${RESET}"; return 1; }

    # ensure only one device connected
    tethering.device || return 1

    # enable the usb link layer device
    echo "${YELLOW}Setting up usb0 link layer device ...${RESET}"
    sleep 1
    adb shell svc usb setFunctions ncm
    sleep 3
    adb shell ip -br link | grep -qE 'usb0' &&
    echo "${GREEN}Enabled the usb0 link layer device${RESET}" ||
    echo "${RED}Failed to enabled the usb0 link layer device${RESET}"

    # extract host new usb interface name
    echo "${YELLOW}Detecting host USB interface ...${RESET}"
    sleep 1
    local host_iface=$(ip -br link show | awk '$1 ~ /^enp0/ {print $1}' | tail -n 1)
    [[ -n "$host_iface" ]] &&
    echo "${GREEN}Detected host USB interface: $host_iface${RESET}" ||
    { echo "${RED}Failed to detect host USB interface${RESET}"; return 1; }

    # ensure ufw allow all incoming network traffics for this interface
    echo "${YELLOW}Setting up firewall rules ...${RESET}"
    sleep 1
    sudo ufw allow in on "$host_iface" comment "android usb-ncm" &&
    echo "${GREEN}Allowed $host_iface in firewall rules${RESET}" ||
    echo "${RED}Failed to allowed $host_iface in firewall rules${RESET}"

    # assign an ip address to the server side
    echo "${YELLOW}Setting up host IP address ...${RESET}"
    local host_ip="10.77.0.1"
    local host_addr="$host_ip/24"
    sudo ip addr flush dev "$host_iface" &&
    sudo ip addr add "$host_addr" dev "$host_iface" &&
    sudo ip link set "$host_iface" up &&
    echo "${GREEN}Added IP address $host_addr to interface $host_iface${RESET}" ||
    { echo "${RED}Failed to added IP address $host_addr to interface $host_iface${RESET}"; return 1; }
    ip -4 addr show dev "$host_iface"

    # start a dhcp server on the host and let
    # note: ip addr through rtnetlink gives permissio error, so impossible to set fixed ip here
    sleep 1
    local client_ip="10.77.0.2"
    sudo dnsmasq \
        --no-daemon \
        --log-dhcp \
        --port=0 \
        --interface="$host_iface" \
        --bind-interfaces \
        --dhcp-authoritative \
        --dhcp-range="$client_ip","$client_ip",255.255.255.0,24h \
        --dhcp-option=3,"$host_ip" \
        &
    dnsmasq_pid=$!
    local dnsmasq_pid_path="/tmp/tethering_dnsmasq.pid"
    echo "$dnsmasq_pid" > "$dnsmasq_pid_path"
    echo "\n${YELLOW}Started temporary dnsmasq DHCP server${RESET}"

    # make the android client request an ip through dhcp
    echo "${YELLOW}Setting up client IP address ...${RESET}"
    sleep 1
    adb shell cmd ethernet set-ip-configuration usb0 dhcp &&
    echo "${GREEN}Made Android client request an IP address via DHCP${RESET}" ||
    echo "${RED}Failed to make Android client request an IP address via DHCP${RESET}"

    # test the usb connection
    echo "${YELLOW}Testing network connectivity from client side ...${RESET}"
    sleep 1
    adb shell ping -c 3 -I usb0 "$host_ip" &&
    echo "${GREEN}Client passed the ping test${RESET}" ||
    echo "${RED}Client failed the ping test${RESET}"

    # disable the client's WiFi
    echo "${YELLOW}Disabling client's WiFi adaptor ...${RESET}"
    sleep 1
    adb shell svc wifi disable &&
    echo "${GREEN}Disabled client's WiFi adaptor${RESET}" ||
    echo "${RED}Failed to disabled client's WiFi adaptor${RESET}"

    # safely kill the dhcp server
    echo "${YELLOW}Cleaning up any ad-hoc spawn dnsmasq DHCP process ...${RESET}"
    sleep 1
    sudo kill $dnsmasq_pid &>/dev/null &&
    rm -f "$dnsmasq_pid_path" &&
    echo "${GREEN}Done clean up any ad-hoc spawn dnsmasq DHCP process${RESET}"

    # make sure adb reverse is off so only tethering is active
    echo "${YELLOW}Removing all adb reverse channels and killing the adb server ...${RESET}"
    sleep 1
    adb reverse --remove-all &&
    adb kill-server &&
    echo "${GREEN}Removed all adb reverse channels and killed adb server${RESET}" ||
    echo "${RED}Failed to remove all adb reverse channels and kill adb server${RESET}"

    #
    sleep 1
    echo "${GREEN}Your USB network is ready!${RESET}"
}

tethering.connect-s7()  {
    # get root permission first
    sudo -v || { echo "${RED}Failed to get root permission${RESET}"; return 1; }

    # ensure only one device connected
    tethering.device || return 1

    # toggle on the android native tethering button
    echo "${YELLOW}Turning on Android native tethering ...${RESET}"
    sleep 1
    adb shell svc usb setFunctions rndis
    sleep 1
    adb shell ip -br link | grep -qE 'rndis0' &&
    echo "${GREEN}Turned on Android native tethering${RESET}" ||
    echo "${RED}Failed to turn on Android native tethering${RESET}"

    # extract host new usb interface name
    echo "${YELLOW}Detecting host USB interface ...${RESET}"
    sleep 1
    local host_iface=$(ip -br link show | awk '$1 ~ /^enp0/ {print $1}' | tail -n 1)
    [[ -n "$host_iface" ]] &&
    echo "${GREEN}Detected host USB interface: $host_iface${RESET}" ||
    { echo "${RED}Failed to detect host USB interface${RESET}"; return 1; }

    # ensure ufw allow all incoming network traffics for this interface
    echo "${YELLOW}Setting up firewall rules ...${RESET}"
    sleep 1
    sudo ufw allow in on "$host_iface" comment "android usb-ncm" &&
    echo "${GREEN}Allowed $host_iface in firewall rules${RESET}" ||
    echo "${RED}Failed to allowed $host_iface in firewall rules${RESET}"

    # disable the client's WiFi
    echo "${YELLOW}Disabling client's WiFi adaptor ...${RESET}"
    sleep 1
    adb shell svc wifi disable &&
    echo "${GREEN}Disabled client's WiFi adaptor${RESET}" ||
    echo "${RED}Failed to disabled client's WiFi adaptor${RESET}"

    # make sure adb reverse is off so only tethering is active
    echo "${YELLOW}Removing all adb reverse channels and killing the adb server ...${RESET}"
    sleep 1
    adb reverse --remove-all &&
    adb kill-server &&
    echo "${GREEN}Removed all adb reverse channels and killed adb server${RESET}" ||
    echo "${RED}Failed to remove all adb reverse channels and kill adb server${RESET}"

    #
    sleep 1
    echo "${GREEN}Your USB network is ready!${RESET}"
}

tethering.disconnect() {
    # ensure only one device connected
    tethering.device || return 1

    # toggle back on client's WiFi
    sleep 1
    adb shell svc wifi enable &&
    echo "${GREEN}Toggled back on client's WiFi${RESET}" ||
    echo "${RED}Failed to toggle back on client's WiFi${RESET}"

    # reset usb functions on android side
    sleep 1
    adb shell svc usb setFunctions mtp
    ! adb shell ip -br link | grep -qE 'rndis0|usb0' &&
    echo "${GREEN}Reset USB functions on android side${RESET}" ||
    echo "${RED}Failed to reset USB functions on android side${RESET}"

    # clean up any ad-hoc spawn dnsmasq dhcp leftover
    local dnsmasq_pid_path="/tmp/tethering_dnsmasq.pid"
    sleep 1
    if [[ -f "$dnsmasq_pid_path" ]]; then
        sudo kill "$(cat "$dnsmasq_pid_path")" 2>/dev/null
        rm -f "$dnsmasq_pid_path"
        echo "${GREEN}Done clean up any ad-hoc spawn dnsmasq DHCP process${RESET}"
    fi
}
