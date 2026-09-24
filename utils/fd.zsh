ensure fd || return


fd.check-backup-for-each-file() {
    # check input arguments
    if [[ -z "$1" || -z "$2" ]]; then
        echo "usage: fd.check-backup-for-each-file <src_dir> <dst_dir>"
        return 1
    fi

    local src_dir="$1"
    local dst_dir="$2"

    # print source files matching criteria
    fd -u -t f . "$src_dir" | while read -r src_file; do
        local fname="${src_file:t}"
        local src_size=$(stat -c %s "$src_file")
        local src_mtime=$(stat -c %Y "$src_file")

        local match_found=0

        # search destination by exact filename
        while read -r dst_file; do
            local dst_size=$(stat -c %s "$dst_file")
            local dst_mtime=$(stat -c %Y "$dst_file")

            if [[ "$src_size" -eq "$dst_size" && "$src_mtime" -eq "$dst_mtime" ]]; then
                echo -e "${GREEN}[FOUND] $src_file -> $dst_file (size: ${src_size}B, mtime: ${src_mtime})${RESET}"
                match_found=1
                break
            fi
        done < <(fd -u -t f -F "$fname" "$dst_dir")

        if [[ "$match_found" -eq 0 ]]; then
            echo -e "${RED}[NOT FOUND] $src_file (size: ${src_size}B, mtime: ${src_mtime})${RESET}"
        fi
    done
}
