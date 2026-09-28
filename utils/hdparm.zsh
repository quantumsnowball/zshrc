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

hdd.unplug() {
    installed luks.unmount || { echo "${RED}Essential shell function luks.unmount is not available, exiting${RESET}"; return 1}

    # args: hdd labels
    local labels=("$@")
    if (( $# == 0 )); then
        labels=(t2018 t2014)
    fi

    # need sudo
    sudo -v || { echo "${RED}Failed to authenticate, unplug aborted${RESET}"; return 1}

    # flush all pending filesystem writes to disk first
    sync

    for label in "${labels[@]}"; do
        echo "${CYAN}----------------------------------------\n  $label\n----------------------------------------${RESET}"

        # unmount
        echo -n "Unmounting $label ... "
        if findmnt "/dev/mapper/$label" &>/dev/null; then
            luks.unmount "$label" &>/dev/null && echo "${GREEN}SUCCESS${RESET}" || {
                echo "${RED}FAILED${RESET}"
                continue
            }
        else
            echo "${YELLOW}NOT MOUNTED${RESET}"
        fi

        # spin down
        local device="/dev/disk/by-partlabel/$label"
        echo -n "Spinning down $label ($device) ... "
        hdparm.spin-down "$device" &>/dev/null && echo "${GREEN}SUCCESS${RESET}" || echo "${RED}FAILED${RESET}"

        # done
        echo "${GREEN}You can safely unplug $label now${RESET}\n"
    done
}
