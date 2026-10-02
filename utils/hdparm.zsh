installed hdparm || return


hdparm.power-state() {
    # if args supplied, execute directly
    (( $# > 0 )) && { sudo hdparm -C "$@"; return; }

    # otherwise, auto-detect physical disks and execute
    local -a drives=($(lsblk -d -n -o PATH,TYPE | awk '$2=="disk" && $1 ~ /\/dev\/sd/ {print $1}'))
    (( ${#drives} == 0 )) && { echo "no drives found"; return 1; }
    sudo hdparm -C "${drives[@]}"
}

hdparm.spin-down() {
    # spin down specified or auto-detected disks
    if (( $# > 0 )); then
        sudo hdparm -y "$@"
    else
        local -a drives=($(lsblk -d -n -o PATH,TYPE | awk '$2=="disk" && $1 ~ /\/dev\/sd/ {print $1}'))
        (( ${#drives} == 0 )) && { echo "no HDD drives found"; return 1; }
        sudo hdparm -y "${drives[@]}"
    fi

    # display states result after
    echo "\nDrive states:"
    hdparm.power-state "$@"
}

hdd.plug() {
    installed luks.mount || { echo "${RED}Essential shell function luks.mount is not available, exiting${RESET}\n"; return 1; }

    # args: hdd labels
    local labels=("$@")
    if (( $# == 0 )); then
        labels=(t2018 t2014)
    fi

    # need sudo
    sudo -v || { echo "${RED}Failed to authenticate, unplug aborted${RESET}\n"; return 1; }


    for label in "${labels[@]}"; do
        echo "${CYAN}----------------------------------------\n  $label\n----------------------------------------${RESET}"

        # mount
        echo "Mounting $label ... "
        if findmnt "/dev/mapper/$label" &>/dev/null; then
            echo "${YELLOW}device already mounted${RESET}\n"
        elif luks.mount "$label"; then
            echo "${GREEN}done${RESET}\n"
        else
            echo "${RED}failed${RESET}\n"
        fi
    done
}

hdd.unplug() {
    installed luks.unmount || { echo "${RED}Essential shell function luks.unmount is not available, exiting${RESET}\n"; return 1; }

    # args: hdd labels
    local labels=("$@")
    if (( $# == 0 )); then
        labels=(t2018 t2014)
    fi

    # need sudo
    sudo -v || { echo "${RED}Failed to authenticate, unplug aborted${RESET}\n"; return 1; }

    # flush all pending filesystem writes to disk first
    sync

    for label in "${labels[@]}"; do
        echo "${CYAN}----------------------------------------\n  $label\n----------------------------------------${RESET}"

        # unmount
        echo -n "Unmounting $label ... "
        if ! findmnt "/dev/mapper/$label" &>/dev/null; then
            echo "${YELLOW}device not mounted${RESET}"
        elif luks.unmount "$label" &>/dev/null; then
            echo "${GREEN}done${RESET}"
        else
            echo "${RED}failed${RESET}\n"
            continue
        fi

        # spin down
        local device="/dev/disk/by-partlabel/$label"
        echo -n "Spinning down $label ($device) ... "
        if [[ ! -b "$device" ]]; then
            echo "${YELLOW}device not found${RESET}\n"
            continue
        elif ! hdparm.spin-down "$device" &>/dev/null; then
            echo "${RED}failed${RESET}\n"
            continue
        else
            echo "${GREEN}done${RESET}"
        fi

        # done
        echo "${GREEN}You can safely unplug $label now${RESET}\n"
    done
}
