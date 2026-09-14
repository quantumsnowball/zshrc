luks.drives() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID
}
luks.drives.list-encrypted() {
    luks.drives | grep crypto_LUKS
}

