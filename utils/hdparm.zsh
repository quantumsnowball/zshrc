installed hdparm || return


hdparm.power-state() {
    # if no args are supplied, detect and check all physical disks
    if [[ $# -eq 0 ]]; then
        local -a drives
        drives=($(lsblk -d -n -o PATH,TYPE | awk '$2=="disk" && $1 ~ /\/dev\/sd/ {print $1}'))

        if [[ ${#drives} -eq 0 ]]; then
            echo "no disk drives found"
            return 1
        fi

        sudo hdparm -C "${drives[@]}"

    # otherwise just pass all the args
    else
        sudo hdparm -C "$@"
    fi
}
hdparm.spin-down() {
    # if no args are supplied, spin down all physical SATA disks
    if [[ $# -eq 0 ]]; then
        local -a drives
        drives=($(lsblk -d -n -o PATH,TYPE | awk '$2=="disk" && $1 ~ /\/dev\/sd/ {print $1}'))

        if [[ ${#drives} -eq 0 ]]; then
            echo "no HDD drives found"
            return 1
        fi

        sudo hdparm -y "${drives[@]}"
    else
        sudo hdparm -y "$@"
    fi

    echo "\nDrive states:"
    hdparm.power-state "$@"
}
