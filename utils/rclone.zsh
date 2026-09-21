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
rclone.remote.check-drive() { rclone.remote.check drive }
rclone.remote.check-sftp() { rclone.remote.check sftp }

# list
rclone.remote.list() { rclone listremotes }
rclone.remote.list-sftp() { rclone listremotes --type sftp }
rclone.remote.list-drive() { rclone listremotes --type drive }

# copy
rclone.copy() {
    # ensure src and dst exists
    (( $# < 2 )) && { echo "usage: rclone.copy <src> <dst> [flags...]" >&2; return 1; }
    local src="$1" dst="$2"; shift 2
    # default to verbose output and show progress
    rclone copy -vP "$src" "$dst" "$@"
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
    rclone sync -vP "$src" "$dst" --track-renames "$@"
}
rclone.sync.preview() {
    rclone.sync "$@" --dry-run
}
