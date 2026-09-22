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
