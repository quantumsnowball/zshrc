luks.drives() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID
}
luks.drives.list-encrypted() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID | grep crypto_LUKS
}
luks.drive.test-passphrase() {
    local target="${1}"
    local slot="${2:-0}"
    [[ -b "$target" ]] || { echo "device $target does not exists"; return 1; }
    echo "Testing passphrase at slot $slot"
    sudo cryptsetup luksOpen --test-passphrase "$target" --key-slot="${slot}" &&
        echo "Passphrase is CORRECT!" || echo "Passphrase is WRONG!"
}
luks.drive.list-keys() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksDump "$1"
}
luks.drive.list-slots() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo systemd-cryptenroll "$1"
}
luks.drive.add-passphrase() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksAddKey "$1"
}
luks.drive.remove-passphrase() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo cryptsetup luksRemoveKey "$1"
}
luks.drive.remove-tpm2-slot() {
    [[ -b "$1" ]] || { echo "device $1 does not exists"; return 1; }
    sudo systemd-cryptenroll --wipe-slot=tpm2 "$1"
}
luks.drive.enable-auto-unlock.by-tpm2() {
    local target="${1}"
    [[ -b "${target}" ]] || { echo "device ${target} does not exist"; return 1 }

    # step 1: enroll key to tpm2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 "${target}" || return 1

    # step 2: extract drive uuid
    local uuid
    uuid=$(sudo blkid -s UUID -o value "${target}")
    if [[ -z "${uuid}" ]]; then
        echo "could not find uuid for ${target}"
        return 1
    fi

    # step 3: auto-update /etc/crypttab if needed
    if sudo grep -q "${uuid}" /etc/crypttab; then
        if ! sudo grep "${uuid}" /etc/crypttab | grep -q "tpm2-device=auto"; then
            echo "updating /etc/crypttab..."
            sudo sed -i "/${uuid}/ s/$/ luks,tpm2-device=auto/" /etc/crypttab
        fi
    else
        echo "adding entry to /etc/crypttab..."
        echo "luks-${uuid} UUID=${uuid} none luks,tpm2-device=auto" | sudo tee -a /etc/crypttab > /dev/null
    fi

    # step 4: rebuild initramfs
    echo "rebuilding initramfs..."
    sudo mkinitcpio -P
    echo "done! reboot to test auto-unlock"
}
