luks.drives() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID
}
luks.drives.list-encrypted() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID | grep crypto_LUKS
}
luks.drive.list-keyslots() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksDump "$1"
}
luks.drive.add-key() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksAddKey "$1"
}
luks.drive.remove-key() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksRemoveKey "$1"
}

