luks.drives() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID
}
luks.drives.list-encrypted() {
    luks.drives | grep crypto_LUKS
}
luks.drive.list-keyslots() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1 }
    sudo cryptsetup luksDump "$1"
}

