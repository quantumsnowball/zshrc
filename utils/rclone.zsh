ensure rclone || return


# check
rclone.remote.check() {
    echo ""
    # run in a subshell to avoid printing the background job debug messages
    (
        # start multiple background jobs to connect to each client
        for name in $(rclone listremotes $1); do
            (
                # basic test is to list the files with depth 1 with a 5s timeout
                timeout 10s rclone lsf "$name" --max-depth 1 &>/dev/null
                res=$?
                if [ $res -eq 0 ]; then
                    printf "%-25s ${GREEN}SUCCESS${RESET}\n" "$name"
                elif [ $res -eq 124 ]; then
                    printf "%-25s ${YELLOW}TIMEOUT${RESET}\n" "$name"
                else
                    printf "%-25s ${RED}FAILED${RESET}\n" "$name"
                fi
            ) &
        done
        # wait before all job done and exit
        wait
    )
    echo ""
}
rclone.remote.check-drive() {
    rclone.remote.check drive
}
rclone.remote.check-sftp() {
    rclone.remote.check sftp
}

# list
rclone.remote.list() {
    rclone listremotes
}
rclone.remote.list-sftp() {
    rclone listremotes --type sftp
}
rclone.remote.list-drive() {
    rclone listremotes --type drive
}

# check
rclone.check() {
    # ensure src and dst exists
    (( $# < 2 )) && { echo "usage: rclone.check <src> <dst> [flags...]" >&2; return 1; }
    local src="$1" dst="$2"; shift 2
    # default to verbose output and show progress
    rclone check -vP "$src" "$dst" "$@"
}

rclone.check-fast() {
    # check using size and modtime only without reading disk hashes
    # use more checkers to speed up
    rclone.check "$@" --checkers 128 --fast-list --size-only
}

# copy
rclone.copy() {
    # ensure src and dst exists
    (( $# < 2 )) && { echo "usage: rclone.copy <src> <dst> [flags...]" >&2; return 1; }
    local src="$1" dst="$2"; shift 2
    # default to verbose output and show progress
    # also will download abuse file, use 64 checkers to speed up
    rclone copy -vP "$src" "$dst" --drive-acknowledge-abuse --checkers 64 "$@"
}
rclone.copy.preview() {
    rclone.copy "$@" --dry-run
}
# copy (sequentially)
rclone.copy-1t() {
    rclone.copy "$@" --transfers=1
}
rclone.copy-1t.preview() {
    rclone.copy "$@" --transfers=1 --dry-run
}

# sync
rclone.sync() {
    # ensure src and dst exists
    (( $# < 2 )) && { echo "usage: rclone.sync <src> <dst> [flags...]" >&2; return 1; }
    local src="$1" dst="$2"; shift 2
    # default to verbose output, show progress
    # use track renames via default strategy (hash)
    # also will download abuse file, use 64 checkers to speed up
    rclone sync -vP -i "$src" "$dst" --drive-acknowledge-abuse --checkers 64 --track-renames "$@"
}
rclone.sync.preview() {
    rclone.sync "$@" --dry-run
}
rclone.sync-fast() {
    # avoid heavy hashing large files but still careful enough not to mix up files
    rclone.sync "$@" --track-renames-strategy modtime --fast-list
}
rclone.sync-fast.preview() {
    rclone.sync "$@" --track-renames-strategy modtime --fast-list --dry-run
}
