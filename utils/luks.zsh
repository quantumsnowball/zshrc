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
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    sudo cryptsetup luksRemoveKey "$target"
}
luks.remove-tpm2-slot() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }
    sudo systemd-cryptenroll --wipe-slot=tpm2 "$target"
}
luks.enable-auto-unlock.by-tpm2() {
    local target; target="$(luks.resolve-label "${1}")" || { echo "Usage: $0 <valid block device path or partlabel>" >&2; return 1; }

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
    # TODO: resolve the label to a mapper
    [[ -n "$1" && -b "$1" && "$1" == /dev/mapper/* ]] || { echo "Usage: $0 <valid /dev/mapper/ block device path>" >&2; return 1; }
    sudo tune2fs -m 0 "$1"
}
luks.list-keyfiles() {
    sudo find /etc/cryptsetup-keys.d/ -type f -exec md5sum {} + 2>/dev/null
}
luks.generate-keyfile() {
    [[ -n "$1" && -e "/dev/disk/by-partlabel/$1" ]] || { echo "Usage: $0 <partlabel>" >&2; return 1; }
    sudo dd if=/dev/urandom of="/etc/cryptsetup-keys.d/$1.key" bs=1024 count=4 status=none && sudo chmod 400 "/etc/cryptsetup-keys.d/$1.key"
    sudo md5sum /etc/cryptsetup-keys.d/$1.key
}
luks.add-keyfile() {
    [[ -n "$1" && -e "/dev/disk/by-partlabel/$1" ]] || { echo "Usage: $0 <partlabel>" >&2; return 1; }
    local label="${1}"
    local keyfile="/etc/cryptsetup-keys.d/$label.key"
    sudo test -e "$keyfile" || { echo "Key file does not exists for $1, run luks.generate-keyfile <label> first" >&2; return 1; }
    local target="$(luks.resolve-label "${label}")"
    sudo cryptsetup luksAddKey "$target" "$keyfile"
}
# luks.remove-keyfile() {
#     [[ -n "$1" && -e "/dev/disk/by-partlabel/$1" ]] || { echo "Usage: $0 <partlabel>" >&2; return 1; }
#     local label="${1}"
#     local keyfile="/etc/cryptsetup-keys.d/$label.key"
# }
luks.mount() {
    local label="${1}"
    local target; target="$(luks.resolve-label "$label")" || { echo "Usage: $0 <partlabel>" >&2; return 1; }
    local mapper_name="$label"
    local mapper_path="$(realpath "/dev/disk/by-label/$label")"
    local keyfile="/etc/cryptsetup-keys.d/${label}.key"
    local mount_point="${2:-/mnt/${label}}"
    if sudo test -e "$keyfile"; then
        echo "Unlocking $target using keyfile $keyfile..."
        sudo cryptsetup open "$target" "$mapper_name" --key-file "$keyfile" || return 1
    else
        echo "Unlocking $target using passphrase..."
        sudo cryptsetup open "$target" "$mapper_name" || return 1
    fi
    sudo mkdir -p "$mount_point"
    sudo mount "$mapper_path" "$mount_point" && echo "Mounted $mapper_path at $mount_point"
}
luks.unmount() {
    local label="$1"
    [[ -n "$1" && -e "/dev/disk/by-label/$1" ]] || { echo "Label $label does not exist" >&2; return 1; }
    local mapper_path="$(realpath "/dev/disk/by-label/$label")"
    local mount_point="$(findmnt -n -o TARGET "$mapper_path")"
    [[ -d "$mount_point" ]] || { echo "Failed to locate mount point from label" >&2; return 1; }
    sudo umount "$mount_point" && echo "Unmounted $mount_point" &&
    sudo rmdir "$mount_point" && echo "Removed $mount_point" &&
    sudo cryptsetup close "$mapper_path" && echo "Closed $mapper_path"
}
