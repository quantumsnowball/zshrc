installed lsblk || return


luks.drives() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID
}
luks.drives-encrypted() {
    lsblk -p -o NAME,FSTYPE,SIZE,MOUNTPOINTS,UUID | grep crypto_LUKS
}
luks.resolve-label() {
    local target="${1}"
    # assert non empty input
    [[ -z "$target" ]] && return 1
    # resolve partition label or use block device path as is
    if [[ ! -b "$target" && -e "/dev/disk/by-partlabel/$target" ]]; then
        target="$(realpath "/dev/disk/by-partlabel/$target")"
        echo "Label resolves to $target" >&2
    fi
    # assert valid block device
    [[ ! -b "$target" ]] && return 1
    # return
    echo "$target"
}
luks.test-passphrase() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    local slot="${2:-0}"
    echo "Testing passphrase for $target at slot $slot"
    sudo cryptsetup luksOpen --test-passphrase "$target" --key-slot="${slot}" &&
        echo "Passphrase is CORRECT!" || echo "Passphrase is WRONG!"
}
luks.list-keys() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    sudo cryptsetup luksDump "$target"
}
luks.list-slots() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    sudo systemd-cryptenroll "$target"
}
luks.add-passphrase() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    sudo cryptsetup luksAddKey "$target"
}
luks.remove-passphrase() {
    [[ -n "$1" && -b "$1" ]] || { echo "Usage: $0 <valid block device path>"; return 1; }
    sudo cryptsetup luksRemoveKey "$1"
}
luks.remove-tpm2-slot() {
    [[ -n "$1" && -b "$1" ]] || { echo "Usage: $0 <valid block device path>"; return 1; }
    sudo systemd-cryptenroll --wipe-slot=tpm2 "$1"
}
luks.enable-auto-unlock.by-tpm2() {
    [[ -n "$1" && -b "$1" ]] || { echo "Usage: $0 <valid block device path>"; return 1; }
    local target="${1}"

    # remove old tpm2 keys
    sudo systemd-cryptenroll --wipe-slot=tpm2 "${target}"

    # enroll key to tpm2
    sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 "${target}"

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
luks.set-reserved-blocks-percentage-to-zero() {
    [[ -n "$1" && -b "$1" && "$1" == /dev/mapper/* ]] || { echo "usage: $0 <valid /dev/mapper/ block device path>"; return 1; }
    sudo tune2fs -m 0 "$1"
}
luks.list-keyfiles() {
    sudo /bin/ls -l /etc/cryptsetup-keys.d/
}
luks.generate-keyfile() {
    [[ -z "$1" ]] && { echo "usage: $0 <label>"; return 1; }
    sudo dd if=/dev/urandom of="/etc/cryptsetup-keys.d/$1.key" bs=1024 count=4 status=none && sudo chmod 400 "/etc/cryptsetup-keys.d/$1.key"
    sudo md5sum /etc/cryptsetup-keys.d/$1.key
}
}
