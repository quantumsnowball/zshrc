[ -v TERMUX_VERSION ] || return


# some Termux common command listed here
alias termux.wake='termux-wake-lock'
alias termux.unwake='termux-wake-unlock'
alias termux.setup-storage='termux-setup-storage'
termux.theme () {
    installed termux-style &&
        termux-style ||
        echo "Please installed termux-style at:\nhttps://github.com/adi1090x/termux-style"
}


# nerd fonts
termux.use-font() {
    dst="$HOME/.termux/font.ttf"
    ln -srf "$1" "$dst"
    termux-reload-settings
}

# backup and restore
termux.backup.backup-home-and-usr-dir-to() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: ${funcstack[1]} <path-to-archive>.tar[.gz|.xz]" >&2
        return 1
    fi
    # ensure the backup dir exists
    mkdir -p "$(dirname "$1")"
    # do a tar -acf to archive home/ and usr/ to a file (.tar, .tar.gz or .tar.xz)
    tar --auto-compress --create --file="$1" --directory=/data/data/com.termux/files ./home ./usr
}
termux.backup.restore-home-and-usr-dir-from() {
    if [ "$#" -ne 1 ] || [ ! -f "$1" ]; then
        echo "Usage: ${funcstack[1]} <path-to-archive>.tar[.gz|.xz]" >&2
        return 1
    fi
    # do a tar -xf to extract an archive file (.tar, .tar.gz or .tar.xz) to restore the home/ and usr/ into files/
    tar --extract --file="$1" --directory=/data/data/com.termux/files --recursive-unlink --preserve-permissions
}
